import 'dart:async';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/injection_container.dart' as di;
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/current_trip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GoogleMapsWidget extends StatefulWidget {
  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  final Location location = Location();

  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;

  late StreamSubscription<LocationData> currentLocationStream;
  bool serviceEnabled = false;
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor customIcon;
  late String _darkMapStyle;
  late String _lightMapStyle;

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/map_style/light.json');
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(50, 50)), 'assets/images/car1.png')
        .then((icon) {
      customIcon = icon;
    });

    super.initState();
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    controller.setMapStyle(_lightMapStyle);
  }

  Future<void> _listenLocation() async {
    Location location = Location();
    location.changeSettings(
      accuracy: LocationAccuracy.low,
    );
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        setState(() {
          _error = err.code;
        });
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((LocationData currentLocation) async {
      final GoogleMapController controller = await _controller.future;
      _moveCamera(
        lat: currentLocation.latitude!.toDouble(),
        long: currentLocation.longitude!.toDouble(),
      );

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
        if (_serviceEnabled) {
          _locationData = await location.getLocation();
          setState(() {
            _error = null;
            _markers.clear();
            _setMapPins([
              LatLng(
                _locationData.latitude!.toDouble(),
                _locationData.longitude!.toDouble(),
              )
            ]);
            _location = currentLocation;
          });
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      _locationData = await location.getLocation();
      if (mounted) {
        setState(() {
          _error = null;
          _markers.clear();
          _setMapPins([
            LatLng(
              _locationData.latitude!.toDouble(),
              _locationData.longitude!.toDouble(),
            )
          ]);
          _location = currentLocation;
          print(_location!.latitude);
          // di.sl<Socket>().emit(
          //   'update_location',
          //   {
          //     "id": getUserId(),
          //     "lng": _location!.longitude,
          //     "lat": _location!.latitude
          //   },
          // );
        });
      }
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();

    _locationSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            rotateGesturesEnabled: true,
            zoomGesturesEnabled: true,
            trafficEnabled: false,
            tiltGesturesEnabled: false,
            scrollGesturesEnabled: true,
            compassEnabled: true,
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: LatLng(
                30.029585,
                31.022356,
              ),
              zoom: 20.47,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _setMapPins([LatLng(30.029585, 31.022356)]);
              _listenLocation();

              _setMapStyle();
            },
            onCameraMove: (position) {},
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: paddingH16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _listenLocation();
                    },
                    icon: const Icon(
                      Icons.location_on,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _setMapPins(List<LatLng> markersLocation) {
    _markers.clear();
    setState(() {
      markersLocation.forEach((markerLocation) {
        _markers.add(Marker(
          markerId: MarkerId(markerLocation.toString()),
          position: markerLocation,
          icon: customIcon,
        ));
      });
    });
  }

  _moveCamera({required double lat, required double long, double? zoom}) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            lat,
            long,
          ),
          zoom: 20.00,
        ),
      ),
    );
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        width: 2,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline({
    required double originLat,
    required double originLong,
    required double destLat,
    required double destLong,
  }) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(originLat, originLong),
      PointLatLng(destLat, destLong),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
