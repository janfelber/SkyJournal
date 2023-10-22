// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
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

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10.4746,
  );
  LatLng _point1 = LatLng(
    0.0,
    0.0,
  );
  LatLng _point2 = LatLng(
    0.0,
    0.0,
  );

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });

    _getCoordinatesFromCity(widget.startDestination, widget.endDestination);

    setupGooglePlex();
  }

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

  Future<LatLng> _getCinty(city) async {
    List<Location> locationsFrom = await locationFromAddress(city);

    if (locationsFrom.isNotEmpty) {
      print(LatLng(locationsFrom[0].latitude, locationsFrom[0].longitude));
      return LatLng(locationsFrom[0].latitude, locationsFrom[0].longitude);
    }
    return LatLng(0.0, 0.0);
  }

  Future<void> setupGooglePlex() async {
    LatLng target = await _getCinty(widget
        .startDestination); // Nahraďte "Názov_mesta" skutočným názvom mesta, pre ktoré chcete získať súradnice
    // Aktualizácia _kGooglePlex
    _kGooglePlex = CameraPosition(
      target: target,
      zoom: 10.4746,
    );
  }

  final Set<Polyline> _polylines = Set();

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
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
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
    );
  }
}
