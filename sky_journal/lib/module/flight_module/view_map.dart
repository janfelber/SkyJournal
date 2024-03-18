// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/theme/color_theme.dart';

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
      print('Chyba pri získavaní súradníc z mesta $cityName: $e');
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

  Future<void> _getCoordinatesFromCity(
      String cityNameFrom, String cityNameTo) async {
    try {
      List<Location> locationsFrom =
          await getLocationFromCityName(cityNameFrom);
      List<Location> locationsTo = await getLocationFromCityName(cityNameTo);

      if (locationsFrom.isNotEmpty && locationsTo.isNotEmpty) {
        setState(() {
          //set the coordinates of the two cities
          _point1 =
              LatLng(locationsFrom[0].latitude, locationsFrom[0].longitude);
          _point2 = LatLng(locationsTo[0].latitude, locationsTo[0].longitude);
          _setInitialCameraPosition(locationsFrom[0]);
        });
      } else {
        print('Nepodarilo sa nájsť súradnice pre mesto $cityNameFrom');
      }
    } catch (e) {
      print('Chyba pri získavaní súradníc: $e');
    }
  }

  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });

    _getCoordinatesFromCity(widget.startDestination, widget.endDestination);
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
          future: getLocationFromCityName(widget.startDestination),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
