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

import 'package:sky_journal/global_widgets/space.dart';

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
  }) : super(key: key);

  @override
  State<FlightDetailsPage> createState() => _FlightDetailsPageState();
}

class _FlightDetailsPageState extends State<FlightDetailsPage> {
  String _mapStyle = '';

  final Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController mapController;

  LatLng _point1 = LatLng(0, 0);
  LatLng _point2 = LatLng(0, 0);

  final Set<Polyline> _polylines = Set();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });

    _getCoordinatesFromCity(widget.startDestination, widget.endDestination);
  }

  Future<List<Location>> getLocationFromCityName(String cityName) async {
    try {
      return await locationFromAddress(cityName);
    } catch (e) {
      print('Chyba pri získavaní súradníc z mesta $cityName: $e');
      return [];
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
          // Nastavte súradnice pre _point1 na získané hodnoty
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

  Future<void> _setInitialCameraPosition(Location location) async {
    try {
      setState(() {
        // Nastavenie inicializačnej pozície kamery na základe získaných zemepisných súradníc
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
        ),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          // Aktualizujte údaje o lete s novými hodnotami
          widget.flightNumber = value['flightNumber'];
          widget.startDate = value['startDate'];
          widget.endDate = value['endDate'];
          widget.startDestination = value['startDestination'];
          widget.endDestination = value['endDestination'];
          widget.timeOfTakeOff = value['timeOfTakeOff'];
          widget.timeOfLanding = value['timeOfLanding'];
          widget.airline = value['airline'];

          _polylines.clear();
          _point1 = LatLng(0, 0);
          _point2 = LatLng(0, 0);

          // Obnovte mapu na pôvodný stav
          _getCoordinatesFromCity(
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
      //latlng is List<LatLng>
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
                                widget.startDestination,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor),
                              ),
                              Space.Y(5),
                              Text(
                                widget.startDestination,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.5)),
                              ),
                              Space.Y(10),
                              FlightCard(
                                startDate: widget.startDate,
                                startDestination: widget.startDestination,
                                endDestination: widget.endDestination,
                                timeOfTakeOff: widget.timeOfTakeOff,
                                timeOfLanding: widget.timeOfLanding,
                                airline: widget.airline,
                                onEdit: _navigateToUpdateFlightPage,
                              ),
                              Space.Y(10),
                              Text(
                                widget.endDestination,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: textColor),
                              ),
                              Space.Y(5),
                              Text(
                                widget.endDestination,
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
                              child: FutureBuilder<List<Location>>(
                                future: getLocationFromCityName(
                                    widget.startDestination),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else {
                                    final targetLatLng = LatLng(
                                        snapshot.data![0].latitude,
                                        snapshot.data![0].longitude);
                                    return GoogleMap(
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: targetLatLng,
                                        zoom: 9,
                                      ),
                                      polylines: _polylines,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        mapController = controller;
                                        mapController.setMapStyle(_mapStyle);
                                        _controller.complete(controller);
                                      },
                                    );
                                  }
                                },
                              ),
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
                                            startDestination:
                                                widget.startDestination,
                                            endDestination:
                                                widget.endDestination,
                                          ));
                                    },
                                    child: Center(
                                      child: Text(
                                        'View More',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Primary),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        )),
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
                              'Pilot Information',
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
                                  Icons.airplanemode_active,
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
                                  Icons.people,
                                  color: textColor.withOpacity(0.5),
                                ),
                                Space.X(10),
                                Text(
                                  'Number of passengers: ' +
                                      widget.numbersOfPassengers,
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
                                  'Average Speed: ' + widget.avgSpeed + 'km/h',
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
                                    Space.X(10),
                                    Text(
                                      'Aircraft Type: Boeing 737',
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
                                    Space.X(10),
                                    Text(
                                      'Seating Layout: 3-3-3',
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
                                    Space.X(10),
                                    Text(
                                      'Max capacity: 388 passengers',
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
