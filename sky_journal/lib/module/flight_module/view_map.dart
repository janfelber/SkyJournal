// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/theme/color_theme.dart';

class ViewMap extends StatefulWidget {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  const ViewMap({
    Key? key,
    required this.endLatitude,
    required this.endLongitude,
    required this.startLatitude,
    required this.startLongitude,
  }) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  String _mapStyle = '';
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  late LatLng _point1;
  late LatLng _point2;

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {}; // Set pre uchovanie značiek (markerov)

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });

    // Nastavenie začiatočných a koncových súradníc trasy
    _point1 = LatLng(widget.startLatitude, widget.startLongitude);
    _point2 = LatLng(widget.endLatitude, widget.endLongitude);

    // Vytvorenie polyline pre zobrazenie trasy
    _polylines.add(Polyline(
      polylineId: PolylineId("line 1"),
      visible: true,
      width: 2,
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      points: MapsCurvedLines.getPointsOnCurve(
        _point1,
        _point2,
      ), // Získanie bodov pre zakrivenú trasu
      color: Primary, // Farba trasy
    ));

    // Pridanie značiek na začiatok a koniec trasy
    _markers.add(
      Marker(
        markerId: MarkerId("startMarker"),
        position: _point1,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen), // Ikona pre začiatok (odlet)
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId("endMarker"),
        position: _point2,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed), // Ikona pre koniec (pristátie)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Flight Route',
      ),
      body: FutureBuilder(
        future:
            Future.delayed(Duration(seconds: 5)), // Simulácia načítania údajov
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Zobraziť načítavací indikátor počas načítania údajov
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
          } else {
            // Zobraziť mapu s trasou, keď je načítanie údajov dokončené
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _point1, // Nastavenie začiatočnej pozície kamery
                zoom: 11,
              ),
              polylines: _polylines, // Zobrazenie trasy v mape
              markers: _markers, // Zobrazenie značiek (markerov) v mape
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController.setMapStyle(_mapStyle);
                _controller.complete(controller);
              },
            );
          }
        },
      ),
    );
  }
}
