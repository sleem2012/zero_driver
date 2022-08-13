import 'dart:async';
import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/logic_layer/rating/rating_cubit.dart';
import 'package:driver/ui_layer/screens/current_trip/current_trip_placeholder.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:driver/ui_layer/widgets/sized_map_with_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/logic_layer/billing_info/billing_info_cubit.dart';
import 'package:driver/logic_layer/trip_info/get_order_list_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BillingInfoScreen extends StatefulWidget {
  final TripInfo tripInfo;
  const BillingInfoScreen({
    Key? key,
    required this.tripInfo,
  }) : super(key: key);

  @override
  State<BillingInfoScreen> createState() => _BillingInfoScreenState();
}

class _BillingInfoScreenState extends State<BillingInfoScreen> {
  double ratingValue = 0;
  TextEditingController noteEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kDefaultColor,
          title: Text('billing'.tr),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: BlocProvider(
          create: (context) =>
              BillingInfoCubit()..getBillingInfo(widget.tripInfo.requestId),
          child: BlocBuilder<BillingInfoCubit, BillingInfoState>(
            builder: (context, state) {
              if (state is BillingInfoStateLoading) {
                return Container(
                  height: SizeConfig.blockSizeVertical * 100,
                  color: Colors.black26,
                  child: const Center(
                    child: SpinKitWave(
                      color: kDefaultColor,
                      size: 50.0,
                    ),
                  ),
                );
              }
              if (state is BillingInfoStateSuccess) {
                return Card(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const CachedImageWidget(
                            imageUrl: 'https://i.ibb.co/rF27hkX/user-1.png',
                            height: 50,
                            width: 50,
                            borderRadius: 50,
                            boxFit: BoxFit.cover,
                          ),
                          title: Text(
                            widget.tripInfo.clientName ?? 'N/A',
                          ),
                          // subtitle: Row(
                          //   children: <Widget>[
                          //     const Text('4.9'),
                          //     sizedBoxW10,
                          //     const Icon(
                          //       Icons.star,
                          //       color: kDefaultColor,
                          //     )
                          //   ],
                          // ),
                          trailing: InkWell(
                            onTap: () async {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: widget.tripInfo.clientMobile,
                              );
                              await launch(launchUri.toString());
                            },
                            child: Container(
                              padding: padding4,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kDefaultColor,
                              ),
                              child: const Icon(
                                Icons.phone_enabled,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${'paymentMethod'.tr}: ${'cash'.tr}',
                              ),
                              Text(
                                '${'price'.tr} : ${state.billingInfo.data!.price}${'currency'.tr}',
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${'companyProfit'.tr} : ${state.billingInfo.data!.companyProfit} %',
                              ),
                            ),
                            Expanded(
                              child: Text(
                                  '${'earning'.tr} : ${state.billingInfo.data!.finalPrice} '),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            sizedBoxW10,
                            Text(
                              widget.tripInfo.startName.toString(),
                            ),
                          ],
                        ),
                        sizedBoxH10,
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                            sizedBoxW10,
                            Expanded(
                              child: Text(
                                widget.tripInfo.endName.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        sizedBoxH10,
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 40,
                          child: SizedMapWithRoutes(
                            longitudeStartPoint: double.parse(
                              state.billingInfo.data!.longitudeStartPoint
                                  .toString(),
                            ),
                            longitudeEndPoint: double.parse(
                              state.billingInfo.data!.longitudeEndPoint
                                  .toString(),
                            ),
                            latitudeEndPoint: double.parse(
                              state.billingInfo.data!.latitudeEndPoint
                                  .toString(),
                            ),
                            latitudeStartPoint: double.parse(
                              state.billingInfo.data!.latitudeStartPoint
                                  .toString(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'rate_trip'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            ratingValue = rating;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            scrollPadding: const EdgeInsets.all(8.0),
                            maxLines: 5,
                            controller: noteEditingController,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 15.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'rate_trip'.tr,
                              // filled: true,
                              // fillColor: Colors.grey,
                              contentPadding: const EdgeInsets.all(8),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is BillingInfoStateError) {
                return Center(
                  child: Text(state.error.toString()),
                );
              }
              return Container();
            },
          ),
        ),
        bottomNavigationBar: BlocConsumer<RatingCubit, RatingState>(
          listener: (context, state) {
            if (state is RatingLoading) {
              showOverlayNotification(
                (context) {
                  return const OverlayLoading();
                },
                position: NotificationPosition.bottom,
                key: const ValueKey('message'),
              );
            }
            if (state is RatingLoaded) {
              Fluttertoast.showToast(
                msg: "done",
              );
              context.read<CheckProfileCubit>().checkProfile();

              context.read<GetOrderListCubit>().getOrderList();
              Navigator.pushNamedAndRemoveUntil(
                  context, CurrentTripPlaceHolder.routeName, (route) => false);
            }
            if (state is RatingLoadingError) {
              context.read<CheckProfileCubit>().checkProfile();

              Fluttertoast.showToast(
                msg: state.message.toString(),
              );
              context.read<GetOrderListCubit>().getOrderList();
              Navigator.pushNamedAndRemoveUntil(
                  context, CurrentTripPlaceHolder.routeName, (route) => false);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: DefaultButton(
                // height: SizeConfig.blockSizeVertical * 5,
                background: kDefaultColor,
                fontSize: 18,
                function: () {
                  if (ratingValue != 0) {
                    context.read<RatingCubit>().rateUser(
                        ratingValue,
                        noteEditingController.text,
                        widget.tripInfo.requestId.toString());
                  } else {
                    context.read<GetOrderListCubit>().getOrderList();
                    Navigator.pushNamedAndRemoveUntil(context,
                        CurrentTripPlaceHolder.routeName, (route) => false);
                  }
                },
                radius: 10,
                text: 'home'.tr,
                titleColor: Colors.white,
                toUpper: false,
                width: SizeConfig.blockSizeHorizontal * 100,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyMap extends StatefulWidget {
  final double orginLat;
  final double orginLong;
  final double destLat;
  final double destLong;
  final int requestId;
  const MyMap({
    Key? key,
    required this.orginLat,
    required this.orginLong,
    required this.destLat,
    required this.destLong,
    required this.requestId,
  }) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final Location location = Location();
  Map<MarkerId, Marker> markers = {};
  final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  @override
  void initState() {
    /// origin marker
    _addMarker(LatLng(widget.orginLat, widget.orginLong), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(widget.destLat, widget.destLong), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    print(widget.requestId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
          widget.orginLat,
          widget.orginLong,
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
        width: 2,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(widget.orginLat, widget.orginLong),
      PointLatLng(widget.destLat, widget.destLong),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }
}
