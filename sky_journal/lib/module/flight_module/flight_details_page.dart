// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, avoid_print, prefer_interpolation_to_compose_strings, prefer_collection_literals, avoid_unnecessary_containers, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/module/flight_module/updateflight_page.dart';
import 'package:sky_journal/module/flight_module/view_map.dart';
import 'package:sky_journal/theme/color_theme.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/module/flight_module/components/flight_card.dart';
import 'package:geocoding/geocoding.dart';
import 'package:csv/csv.dart';

import 'package:sky_journal/global_widgets/space.dart';

class AirportData {
  final String ident;
  final String municipality;
  final double latitude;
  final double longitude;

  AirportData({
    required this.ident,
    required this.municipality,
    required this.latitude,
    required this.longitude,
  });
}

class FlightDetailsPage extends StatefulWidget {
  String flightNumber;
  String startDate;
  String endDate;
  String startDestination;
  String endDestination;
  String timeOfTakeOff;
  String timeOfLanding;
  String airline;
  String numbersOfPassengers;
  String avgSpeed;
  String typeOfAircraft;
  String pilotFunction;

  FlightDetailsPage({
    Key? key,
    required this.flightNumber,
    required this.startDate,
    required this.endDate,
    required this.startDestination,
    required this.endDestination,
    required this.timeOfTakeOff,
    required this.timeOfLanding,
    required this.airline,
    required this.numbersOfPassengers,
    required this.avgSpeed,
    required this.typeOfAircraft,
    required this.pilotFunction,
  }) : super(key: key);

  @override
  State<FlightDetailsPage> createState() => _FlightDetailsPageState();
}

class _FlightDetailsPageState extends State<FlightDetailsPage> {
  String _mapStyle = '';

  final Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController mapController;

  bool _isMapLoaded = false;

  LatLng _point1 = LatLng(0, 0);
  LatLng _point2 = LatLng(0, 0);

  final Set<Polyline> _polylines = Set();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  List<AirportData> airports = [];

  Future<void> loadAirportDataCoords() async {
    final String data =
        await rootBundle.loadString('assets/airports_coords.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

    if (csvTable.isNotEmpty) {
      setState(() {
        airports = csvTable.map((row) {
          if (row.length >= 4) {
            return AirportData(
              ident: row[0].toString(),
              latitude: double.tryParse(row[1].toString()) ?? 0.0,
              longitude: double.tryParse(row[2].toString()) ?? 0.0,
              municipality: row[3].toString(),
            );
          } else {
            return AirportData(
                ident: '', municipality: '', latitude: 0.0, longitude: 0.0);
          }
        }).toList();
      });
    }
  }

  Future<List<AirportData>> getAirportDataFromCode(String airportCode) async {
    try {
      AirportData? airport = airports.firstWhere(
        (element) =>
            element.ident.trim().toUpperCase() == airportCode.toUpperCase(),
        orElse: () => AirportData(
            ident: '', municipality: '', latitude: 0.0, longitude: 0.0),
      );

      if (airport != null) {
        return [airport]; // Return a list containing the airport data
      } else {
        print('Airport with code $airportCode not found.');
        return []; // Return an empty list if airport not found
      }
    } catch (e) {
      print('Error with getting airport data: $e');
      return []; // Return an empty list if any error occurs
    }
  }

  Future<void> _getCoordinatesFromAirport(
      String startAirportCode, String endAirportCode) async {
    try {
      AirportData? startAirport = airports.firstWhere(
        (element) =>
            element.ident.trim().toUpperCase() ==
            startAirportCode.toUpperCase(),
        orElse: () => AirportData(
            ident: '',
            municipality: '',
            latitude: 0.0,
            longitude: 0.0), // Provide default AirportData
      );

      AirportData? endAirport = airports.firstWhere(
        (element) =>
            element.ident.trim().toUpperCase() == endAirportCode.toUpperCase(),
        orElse: () => AirportData(
            ident: '',
            municipality: '',
            latitude: 0.0,
            longitude: 0.0), // Provide default AirportData
      );

      if (startAirport != null && endAirport != null) {
        setState(() {
          _point1 = LatLng(startAirport.latitude, startAirport.longitude);
          _point2 = LatLng(endAirport.latitude, endAirport.longitude);
        });
      } else {
        print('One or both airports not found.');
        return;
      }
    } catch (e) {
      print('Error with getting coordinates: $e');
    }
  }

  void _navigateToUpdateFlightPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpadateFlight(
          flightNumber: widget.flightNumber,
          startDate: widget.startDate,
          endDate: widget.endDate,
          startDestination: widget.startDestination,
          endDestination: widget.endDestination,
          timeOfTakeOff: widget.timeOfTakeOff,
          timeOfLanding: widget.timeOfLanding,
          airline: widget.airline,
          typeOfAircraft: widget.typeOfAircraft,
          pilotFunction: widget.pilotFunction,
        ),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          widget.flightNumber = value['flightNumber'];
          widget.startDate = value['startDate'];
          widget.endDate = value['endDate'];
          widget.startDestination = value['startDestination'];
          widget.endDestination = value['endDestination'];
          widget.timeOfTakeOff = value['timeOfTakeOff'];
          widget.timeOfLanding = value['timeOfLanding'];
          widget.airline = value['airline'];
          widget.typeOfAircraft = value['typeOfAircraft'];
          widget.pilotFunction = value['pilotFunction'];

          _polylines.clear();
          _point1 = LatLng(0, 0);
          _point2 = LatLng(0, 0);

          // Re-fetch the coordinates for the start and end destination
          _getCoordinatesFromAirport(
              widget.startDestination, widget.endDestination);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _polylines.add(Polyline(
      polylineId: PolylineId("line 1"),
      visible: true,
      width: 2,
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      points: MapsCurvedLines.getPointsOnCurve(
          _point1, _point2), // Invoke lib to get curved line points
      color: Primary,
    ));
    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(
        title: 'Flight Details',
      ),
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/svg/flight_path.svg',
                                color: textColor,
                                semanticsLabel: 'A red up arrow'),
                          ],
                        ),
                        Space.X(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.startDestination.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor),
                              ),
                              Space.Y(5),
                              Text(
                                widget.startDestination.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.5)),
                              ),
                              Space.Y(10),
                              FlightCard(
                                startDate: widget.startDate,
                                startDestination:
                                    widget.startDestination.toUpperCase(),
                                endDestination:
                                    widget.endDestination.toUpperCase(),
                                timeOfTakeOff: widget.timeOfTakeOff,
                                timeOfLanding: widget.timeOfLanding,
                                airline: widget.airline,
                                onEdit: _navigateToUpdateFlightPage,
                              ),
                              Space.Y(10),
                              Text(
                                widget.endDestination.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor),
                              ),
                              Space.Y(5),
                              Text(
                                widget.endDestination.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Space.Y(20),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: cards,
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: FutureBuilder<List<AirportData>>(
                              future: Future.delayed(
                                  Duration(seconds: 5),
                                  () => getAirportDataFromCode(
                                      widget.startDestination)),
                              builder: (context, snapshot) {
                                if (!_isMapLoaded) {
                                  // Zobraziť tlačidlo "Load Map"
                                  return Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isMapLoaded = true;
                                        });
                                        loadAirportDataCoords().then((_) {
                                          _getCoordinatesFromAirport(
                                              widget.startDestination,
                                              widget.endDestination);
                                        });
                                      },
                                      child: Text(
                                        'Load Map',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Počas načítavania údajov zobraziť GIF sťahovania
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'lib/icons/worldwide.gif', // GIF sťahovania
                                          height: 60,
                                          width: 60,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Loading Map',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty &&
                                    _point1.latitude != 0 &&
                                    _point2.latitude != 0) {
                                  final targetLatLng = LatLng(
                                      snapshot.data![0].latitude,
                                      snapshot.data![0].longitude);
                                  return Stack(
                                    children: [
                                      GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: CameraPosition(
                                          target: targetLatLng,
                                          zoom: 11,
                                        ),
                                        polylines: _polylines,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          mapController = controller;
                                          mapController.setMapStyle(_mapStyle);
                                          _controller.complete(controller);
                                        },
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: GestureDetector(
                                            onTap: () {
                                              pushToNewPage(
                                                context,
                                                ViewMap(
                                                  startLatitude:
                                                      _point1.latitude,
                                                  startLongitude:
                                                      _point1.longitude,
                                                  endLatitude: _point2.latitude,
                                                  endLongitude:
                                                      _point2.longitude,
                                                ),
                                              );
                                            },
                                            child: Center(
                                              child: Text(
                                                'View More',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // If the coordinates are not available, show a message
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'lib/icons/close.png',
                                          height: 60,
                                          width: 100,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'No route available between ${widget.startDestination} and ${widget.endDestination}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Space.Y(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: cards,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FLIGHT INFORMATION',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.3)),
                            ),
                            Space.Y(5),
                            Text(
                              'Flight Details',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 24,
                                color: textColor,
                              ),
                            ),
                            Space.Y(20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.airplane_ticket,
                                  color: textColor.withOpacity(0.5),
                                ),
                                Space.X(10),
                                Text(
                                  'Flight Number: ' + widget.flightNumber,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Space.Y(20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: textColor.withOpacity(0.5),
                                ),
                                Space.X(10),
                                Text(
                                  'Pilot Function: ' + widget.pilotFunction,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Space.Y(20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.people,
                                  color: textColor.withOpacity(0.5),
                                ),
                                Space.X(10),
                                Text(
                                  'Number of passengers: ' +
                                      (widget.airline == 'Private'
                                          ? '1'
                                          : widget.numbersOfPassengers),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Space.Y(20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.speed,
                                  color: textColor.withOpacity(0.5),
                                ),
                                Space.X(10),
                                Text(
                                  'Average Speed: ' +
                                      (widget.airline == 'Private'
                                          ? '500'
                                          : widget.avgSpeed) +
                                      'km/h',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Space.Y(20),
                          ],
                        ),
                      ),
                    ),
                    Space.Y(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: cards,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 0, top: 10, bottom: 15),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AIRCRAFT INFORMATION',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: textColor.withOpacity(0.3)),
                                ),
                                Space.Y(5),
                                Text(
                                  'Aircraft Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                      color: textColor),
                                ),
                                Space.Y(20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.flight,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                    Space.X(10),
                                    Text(
                                      'Aircraft Type: ' + widget.typeOfAircraft,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: textColor),
                                    ),
                                  ],
                                ),
                                Space.Y(20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.flight_class,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                    Space.X(10),
                                    Text(
                                      'Seating Layout: ' +
                                          (widget.airline == 'Private'
                                              ? '1-1'
                                              : '3-3-3'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: textColor),
                                    ),
                                  ],
                                ),
                                Space.Y(20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.airline_seat_recline_extra,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                    Space.X(10),
                                    Text(
                                      'Max capacity: ' +
                                          (widget.airline == 'Private'
                                              ? '6 '
                                              : '388 ') +
                                          'passengers',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: textColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Space.Y(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
