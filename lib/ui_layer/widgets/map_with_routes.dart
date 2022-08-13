import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:driver/ui_layer/screens/current_trip/current_trip_placeholder.dart';
import 'package:driver/ui_layer/screens/layout/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;

import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/logic_layer/change_status/change_status_cubit.dart';
import 'package:driver/logic_layer/start_or_finish/start_or_finish_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/billing/billing_info_screen.dart';
import 'package:driver/ui_layer/screens/permission/permission_screen.dart';
import 'package:driver/ui_layer/widgets/current_trip_widget.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:nations/src/extensions/string.dart';

class MapWithRoutes extends StatefulWidget {
  final TripInfo tripInfo;
  final String? distance;
  final String? time;
  final bool? haveNewTrip;
  bool newTrip = false ;
   MapWithRoutes({
    Key? key,
    required this.tripInfo,
    this.distance,
    this.time,
    this.haveNewTrip,
  }) : super(key: key);

  @override
  _MapWithRoutesState createState() => _MapWithRoutesState();
}

class _MapWithRoutesState extends State<MapWithRoutes>
    with WidgetsBindingObserver {
  final Location location = Location();
  Map<MarkerId, Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  LocationData? _location;
  double? latitude;
  double? longitude;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  bool isSent = true;
  double totalDistance = 0;
  setMarkers() async {
    final markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)), 'assets/images/car1.png');

    _addMarker(
        LatLng(
          double.parse(widget.tripInfo.latitudeStartPoint!),
          double.parse(widget.tripInfo.longitudeStartPoint!),
        ),
        "origin",
        markerIcon);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    /// origin marker

    /// destination marker
    _addMarker(
        LatLng(double.parse(widget.tripInfo.latitudeEndPoint!),
            double.parse(widget.tripInfo.longitudeEndPoint!)),
        "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    setMarkers();
    super.initState();
    _listenLocation();
  }
  final Location myLocation = Location();
  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
          if (err is PlatformException) {
            _error = err.code;
          }
          _locationSubscription?.cancel();
          _locationSubscription = null;
        }).listen((LocationData currentLocation) async {
          _error = null;
          _location = currentLocation;
          latitude = double.parse(_location!.latitude!.toStringAsFixed(3));
          longitude = double.parse(_location!.longitude!.toStringAsFixed(3));
          if (isSent) {
            print('is sent $isSent');
            isSent = false;
            print('is sent $isSent');
            print('first');
            double calculateDistance(lat1, lon1, lat2, lon2){
              var p = 0.017453292519943295;
              var c = cos;
              var a = 0.5 - c((lat2 - lat1) * p)/2 +
                  c(lat1 * p) * c(lat2 * p) *
                      (1 - c((lon2 - lon1) * p))/2;
              return 12742 * asin(sqrt(a));
            }
            totalDistance = calculateDistance(_location!.latitude,_location!.longitude,double.parse('${widget.tripInfo.latitudeEndPoint}'),double.parse('${widget.tripInfo.longitudeEndPoint}'));
            print(totalDistance.toStringAsFixed(1));
            if(totalDistance <= 2.0 && widget.haveNewTrip == false){
              print('true');
              setState(() {
                widget.newTrip = true ;
              });
            }
            // Future.delayed(Duration(seconds: 5))
            //     .then((value) => di.sl<Socket>().emit(
            //   'update_location',
            //   {
            //     "id": getUserId(),
            //     "lng": _location!.longitude,
            //     "lat": _location!.latitude,
            //     "time": DateTime.now().toString()
            //   },
            // ));
          }
          isSent = false;
          if (longitude != null &&
              latitude != null &&
              double.parse(_location!.longitude!.toStringAsFixed(3),) != longitude &&
              double.parse(_location!.latitude!.toStringAsFixed(3),) != latitude) {
              print('update_location');
              double calculateDistance(lat1, lon1, lat2, lon2){
              var p = 0.017453292519943295;
              var c = cos;
              var a = 0.5 - c((lat2 - lat1) * p)/2 +
                  c(lat1 * p) * c(lat2 * p) *
                      (1 - c((lon2 - lon1) * p))/2;
              return 12742 * asin(sqrt(a));
            }
              totalDistance = calculateDistance(_location!.latitude,_location!.longitude,double.parse('${widget.tripInfo.latitudeEndPoint}'),double.parse('${widget.tripInfo.longitudeEndPoint}'));
              print(totalDistance.toStringAsFixed(1));
              if(totalDistance <= 2.0 && widget.haveNewTrip == false){
                print('true');
                setState(() {
                  widget.newTrip = true ;
                });
              }
            // di.sl<Socket>().emit(
            //   'update_location',
            //   {
            //     "id": getUserId(),
            //     "lng": _location!.longitude,
            //     "lat": _location!.latitude,
            //     "time": DateTime.now().toString()
            //   },
            // );
          }
        });
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: SizeConfig.blockSizeVertical * 15,
          ),
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
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(widget.tripInfo.latitudeStartPoint!),
                double.parse(widget.tripInfo.longitudeStartPoint!),
              ),
              zoom: 20.47,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _getPolyline();
              // _listenLocation();

              // _setMapStyle();
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
                CurrentTripWidget(
                  tripInfo: widget.tripInfo,
                  distance: widget.distance,
                  time: widget.time,
                )
              ],
            ),
          ),

          ConditionalBuilder(
            condition: widget.newTrip == true,
            builder: (context)=>  Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, LayoutScreen.routeName);
                  },
                  child: Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.1,
                      height: 40,
                      color: Colors.green[200],
                      child: Center(child: Text('accept_new_trips'.tr,style: TextStyle(color: Colors.black),),),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/2.4,
                ),
              ],
            ),
            fallback: (context)=> Container(),
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

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(double.parse(widget.tripInfo.latitudeStartPoint!),
          double.parse(widget.tripInfo.longitudeStartPoint!)),
      PointLatLng(double.parse(widget.tripInfo.latitudeEndPoint!),
          double.parse(widget.tripInfo.longitudeEndPoint!)),
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

openMapsSheet(context,
    {required double startLat,
    required double startLong,
    required double endLat,
    required double endLong}) async {
  try {
    final coords = launcher.Coords(endLat, endLong);
    final availableMaps = await launcher.MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(coords: coords, title: ''),
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } catch (e) {
    print(e);
  }
}
