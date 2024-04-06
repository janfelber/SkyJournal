// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:sky_journal/imports/flight_module_imports/flight_imports.dart';

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
  final Set<Marker> _markers = {}; // Set for markers

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });

    // Set start and end points for the route
    _point1 = LatLng(widget.startLatitude, widget.startLongitude);
    _point2 = LatLng(widget.endLatitude, widget.endLongitude);

    // Create a polyline for the route
    _polylines.add(Polyline(
      polylineId: PolylineId("line 1"),
      visible: true,
      width: 2,
      patterns: [PatternItem.dash(30), PatternItem.gap(10)],
      points: MapsCurvedLines.getPointsOnCurve(
        _point1,
        _point2,
      ), // Get points on the curve
      color: Primary, // Color of the route
    ));

    // Set markers for the start and end points
    _markers.add(
      Marker(
        markerId: MarkerId("startMarker"),
        position: _point1,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId("endMarker"),
        position: _point2,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
        future: Future.delayed(
            Duration(seconds: 5)), // Load the map after 5 seconds
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while data is being loaded
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
            // Show the map after data is loaded
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target:
                    _point1, // Set the initial camera position to the start point
                zoom: 11,
              ),
              polylines: _polylines, // Show the route on the map
              markers: _markers, // Show the markers on the map
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
