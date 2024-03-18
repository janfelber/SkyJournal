// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/theme/color_theme.dart';

import 'flight_details_page.dart';

class ViewMap extends StatefulWidget {
  final String startDestination;
  final String endDestination;

  const ViewMap(
      {super.key,
      required this.startDestination,
      required this.endDestination});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  String _mapStyle = '';

  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  LatLng _point1 = LatLng(0, 0);
  LatLng _point2 = LatLng(0, 0);

  Future<List<Location>> getLocationFromCityName(String cityName) async {
    try {
      String normalizedCityName = cityName.toLowerCase();
      return await locationFromAddress(normalizedCityName);
    } catch (e) {
      print('Error with getting coordinates for $cityName: $e');
      return [];
    }
  }

  Future<void> _setInitialCameraPosition(Location location) async {
    try {
      setState(() {
        // set the initial camera position to the location of the first city
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 10.4746,
            ),
          ),
        );
      });
    } catch (e) {
      print('Chyba pri nastavovaní kamery: $e');
    }
  }

  List<AirportData> airports = [];

  String getCityName(String airportCode) {
    AirportData? airport = airports.firstWhere(
      (element) =>
          element.ident.trim().toUpperCase() == airportCode.toUpperCase(),
      orElse: () => AirportData(ident: '', municipality: ''),
    );

    if (airport.ident.isEmpty) {
      return airportCode;
    }
    return airport.municipality;
  }

  Future<void> _getCoordinatesFromCity(
      String cityNameFrom, String cityNameTo) async {
    try {
      List<Location> locationsFrom = await getLocationFromCityName(
        getCityName(widget.startDestination.toUpperCase()),
      );
      List<Location> locationsTo = await getLocationFromCityName(
        getCityName(widget.endDestination.toUpperCase()),
      );

      if (locationsFrom.isNotEmpty && locationsTo.isNotEmpty) {
        setState(() {
          _point1 =
              LatLng(locationsFrom[0].latitude, locationsFrom[0].longitude);
          _point2 = LatLng(locationsTo[0].latitude, locationsTo[0].longitude);
          _setInitialCameraPosition(locationsFrom[0]);
        });
      } else {
        return;
      }
    } catch (e) {
      print('Error with getting coordinates: $e');
    }
  }

  Future<void> loadAirportData() async {
    final String data = await rootBundle.loadString('assets/airports.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

    if (csvTable.isNotEmpty) {
      setState(() {
        airports = csvTable.map((row) {
          if (row.length >= 2) {
            return AirportData(
              ident: row[0]
                  .toString(), // Assuming airport code is in the first column
              municipality: row[1]
                  .toString(), // Assuming municipality name is in the second column
            );
          } else {
            // Handle case where row doesn't contain enough data
            return AirportData(ident: '', municipality: '');
          }
        }).toList();
      });
    }
  }

  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });

    loadAirportData().then((_) {
      getCityName(widget.startDestination);
      getCityName(widget.endDestination);
      _getCoordinatesFromCity('Hannen Airport', 'Heathrow Airport');
      _getCoordinatesFromCity(widget.startDestination, widget.endDestination);
    });
  }

  @override
  Widget build(BuildContext context) {
    _polylines.add(Polyline(
      polylineId: PolylineId("line 1"),
      visible: true,
      width: 2,
      //latlng is List<LatLng>
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      points: MapsCurvedLines.getPointsOnCurve(
          _point1, _point2), // Invoke lib to get curved line points
      color: Primary,
    ));
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Map Detail Of Flight',
      ),
      body: Container(
        child: FutureBuilder<List<Location>>(
          future: Future.delayed(
              Duration(seconds: 2),
              () => getLocationFromCityName(
                  getCityName(widget.startDestination))),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Loading Map', style: TextStyle(fontSize: 20)),
                    Image(
                      image: AssetImage('lib/icons/worldwide.gif'),
                      height: 60,
                      width: 60,
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final targetLatLng = LatLng(
                  snapshot.data![0].latitude, snapshot.data![0].longitude);
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: targetLatLng,
                  zoom: 9,
                ),
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  mapController.setMapStyle(_mapStyle);
                  _controller.complete(controller);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
