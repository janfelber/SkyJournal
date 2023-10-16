// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/pages/view_map.dart';
import 'package:sky_journal/theme/color_theme.dart';
import 'package:sky_journal/util/button.dart';
import 'package:sky_journal/util/routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sky_journal/util/space.dart';
import 'package:geocoding/geocoding.dart';

class FlightDetailsPage extends StatefulWidget {
  final String flightNumber;
  final String startDate;
  final String endDate;
  final String startDestination;
  final String endDestination;
  final String timeOfTakeOff;
  final String timeOfLanding;
  final String airline;

  const FlightDetailsPage(
      {super.key,
      required this.flightNumber,
      required this.startDate,
      required this.endDate,
      required this.startDestination,
      required this.endDestination,
      required this.timeOfTakeOff,
      required this.timeOfLanding,
      required this.airline});

  @override
  State<FlightDetailsPage> createState() => _FlightDetailsPageState();
}

class _FlightDetailsPageState extends State<FlightDetailsPage> {
  String _mapStyle = '';

  final Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController mapController;

  LatLng _point1 = LatLng(
    0.0,
    0.0,
  );
  LatLng _point2 = LatLng(
    0.0,
    0.0,
  );

  final Set<Polyline> _polylines = Set();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(48.148598, 17.107748),
    zoom: 10.4746,
  );

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });

    _getCoordinatesFromCity(widget.startDestination, widget.endDestination);
  }

  // Metóda pre získanie súradníc mesta zo zadaného názvu
  Future<void> _getCoordinatesFromCity(
      String cityNameFrom, String cityNameTo) async {
    try {
      List<Location> locationsFrom = await locationFromAddress(cityNameFrom);
      List<Location> locationsTo = await locationFromAddress(cityNameTo);

      if (locationsFrom.isNotEmpty && locationsTo.isNotEmpty) {
        setState(() {
          // Nastavte súradnice pre _point1 na získané hodnoty
          _point1 =
              LatLng(locationsFrom[0].latitude, locationsFrom[0].longitude);
          _point2 = LatLng(locationsTo[0].latitude, locationsTo[0].longitude);
        });
      } else {
        print('Nepodarilo sa nájsť súradnice pre mesto $locationsFrom');
      }
    } catch (e) {
      print('Chyba pri získavaní súradníc: $e');
    }
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
      appBar: AppBar(
        title: Text('Flight Details'),
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
                        Text(
                          '${widget.startDestination}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Space.X(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Space.Y(5),
                              Space.Y(10),
                              Space.Y(10),
                              Space.Y(5),
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
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: _kGooglePlex,
                                polylines: _polylines,
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;

                                  mapController.setMapStyle(_mapStyle);

                                  _controller.complete(controller);
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
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
                    Space.Y(20),
                    Space.Y(100),
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
