import 'dart:async';

import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/map_with_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:image/image.dart' as img;

class SizedMapWithRoutes extends StatefulWidget {
  final num longitudeStartPoint;
  final num latitudeStartPoint;
  final num longitudeEndPoint;
  final num latitudeEndPoint;

  const SizedMapWithRoutes({
    Key? key,
    required this.longitudeStartPoint,
    required this.latitudeStartPoint,
    required this.longitudeEndPoint,
    required this.latitudeEndPoint,
  }) : super(key: key);

  @override
  State<SizedMapWithRoutes> createState() => _SizedMapWithRoutesState();
}

class _SizedMapWithRoutesState extends State<SizedMapWithRoutes>
    with WidgetsBindingObserver {
  Map<MarkerId, Marker> markers = {};
  final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates2 = [];
  late LocationData myLocation;

  Future<LatLng> getMyLocation() async {
    Location location = Location();
    final locationData = await location.getLocation();

    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<PointLatLng> getMyPoint() async {
    final locationData = await getMyLocation();

    return PointLatLng(locationData.latitude, locationData.longitude);
  }

  BitmapDescriptor? customIcon;

  setMarkers() async {
    final markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(1, 1),
        ),
        'assets/images/car1.png');

    _addMarker(
        LatLng(widget.latitudeStartPoint.toDouble(),
            widget.longitudeStartPoint.toDouble()),
        "origin",
        BitmapDescriptor.defaultMarkerWithHue(10));
  }

  setMYMarkers() async {
    final markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size(1, 1),
        ),
        'assets/images/car1.png');
    _addMarker(
      await getMyLocation(),
      "location",
      markerIcon,
    );
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // getMyLocation2();
    /// origin marker

    /// destination marker
    print(customIcon.toString());
    _addMarker(
        LatLng(widget.latitudeEndPoint.toDouble(),
            widget.longitudeEndPoint.toDouble()),
        "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    setMarkers();
    setMYMarkers();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final controller1 = await _controller.future;

      controller1.setMapStyle("[]");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.latitudeStartPoint.toDouble(),
              widget.longitudeStartPoint.toDouble(),
            ),
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _getPolyline();
            _getPolyline2();
            controller.animateCamera(
              CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                      southwest: LatLng(
                        widget.latitudeStartPoint <= widget.latitudeEndPoint
                            ? widget.latitudeStartPoint.toDouble()
                            : widget.latitudeEndPoint.toDouble(),
                        widget.longitudeStartPoint <= widget.longitudeEndPoint
                            ? widget.longitudeStartPoint.toDouble()
                            : widget.longitudeEndPoint.toDouble(),
                      ),
                      northeast: LatLng(
                          widget.latitudeStartPoint <= widget.latitudeEndPoint
                              ? widget.latitudeEndPoint.toDouble()
                              : widget.latitudeStartPoint.toDouble(),
                          widget.longitudeStartPoint <= widget.longitudeEndPoint
                              ? widget.longitudeEndPoint.toDouble()
                              : widget.longitudeStartPoint.toDouble())),
                  60),
            );
            // _listenLocation();

            // _setMapStyle();
          },
          onCameraMove: (position) {},
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: InkWell(
              onTap: () {
                openMapsSheet(context,
                    startLong: (widget.longitudeStartPoint.toDouble()),
                    endLat: (widget.latitudeEndPoint.toDouble()),
                    endLong: (widget.longitudeEndPoint.toDouble()),
                    startLat: (widget.latitudeStartPoint.toDouble()));
              },
              child: Container(
                margin: padding8,
                height: SizeConfig.blockSizeVertical * 5,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/icons/google-maps.png',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 2);
    polylines[id] = polyline;
    setState(() {});
  }
  _addPolyLine2() {
    PolylineId id = const PolylineId("poly2");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates2,
        width: 2);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(widget.latitudeStartPoint.toDouble(),
          widget.longitudeStartPoint.toDouble()),
      PointLatLng(widget.latitudeEndPoint.toDouble(),
          widget.longitudeEndPoint.toDouble()),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _getPolyline2() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      await getMyPoint(),
      PointLatLng(widget.latitudeStartPoint.toDouble(),
          widget.longitudeStartPoint.toDouble()),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates2.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine2();
  }
}
