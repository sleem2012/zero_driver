import 'dart:convert';

import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/logic_layer/start_or_finish/start_or_finish_cubit.dart';
import 'package:driver/ui_layer/screens/current_trip/current_trip_placeholder.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driver/injection_container.dart' as di;
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/logic_layer/change_status/change_status_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:nations/nations.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../map_with_routes.dart';
import '../sized_map_with_routes.dart';

class OrderDetailsBottomSheet extends StatefulWidget {
  final TripInfo tripInfo;
  const OrderDetailsBottomSheet({
    Key? key,
    required this.tripInfo,
  }) : super(key: key);

  @override
  State<OrderDetailsBottomSheet> createState() =>
      _OrderDetailsBottomSheetState();
}

class _OrderDetailsBottomSheetState extends State<OrderDetailsBottomSheet> {
  showNotifications({required String message, required int tripId}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      'logo',
    );
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification:
                (int i, String? val, String? val2, String? val3) {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
          (Route<dynamic> route) => false);
    });
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
          (Route<dynamic> route) => false);
    });
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'your channel id_2',
      'your channel name_2',
      channelDescription: 'your channel description_2',
      priority: Priority.max,
      playSound: true,
      importance: Importance.max,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      "${'trip_number'.tr} $tripId",
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocConsumer<ChangeStatusCubit, ChangeStatusState>(
        listener: (context, state) async {
          if (state is ChangeStatusStateLoading) {
            showOverlayNotification(
              (context) {
                return const OverlayLoading();
              },
              position: NotificationPosition.bottom,
              key: const ValueKey('message'),
            );
          }
          if (state is AcceptTripSuccess) {
            Location location = Location();
            final locationData = await location.getLocation();
            context.read<StartOrFinishCubit>().emit(StartOrFinishInitial());
            di.sl<Socket>().emit('accept_trip', {
              "distance": state.distance.toString(),
              "time": (state.tripTime),
              "request_id": widget.tripInfo.requestId,
              "name": getUserName(),
              "phone": getUserPhone(),
              "image": getUserImage().toString(),
              "latitude": locationData.latitude.toString(),
              "longitude": locationData.longitude.toString(),
              'car_color': getCarColor(),
              'car_model': getCarModel(),
              'car_number': getCarNumber(),
              'first_lat': widget.tripInfo.latitudeStartPoint,
              'first_long': widget.tripInfo.longitudeStartPoint,
              'trip_price': widget.tripInfo.tripPrice,
              'driver_rating': getUserRate()
            });
            di.sl<Socket>().emit(
              'remove_trip',
              {
                "request_id": widget.tripInfo.requestId,
              },
            );
            if (state.haveTrip == true) {
              showNotifications(
                  message:
                      '${'you_accepted_offer'.tr} ${widget.tripInfo.tripPrice}',
                  tripId: widget.tripInfo.requestId!);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MapWithRoutes(
                    tripInfo: widget.tripInfo,
                    distance: state.distance.toString(),
                    time: (state.tripTime),
                  ),
                ),
              );
            }
            if (state.haveTrip == false) {
              Navigator.pushReplacementNamed(
                  context, CurrentTripPlaceHolder.routeName);
            }
          }

          if (state is ChangeStatusStateError) {
            Fluttertoast.showToast(
                msg: context.read<ChangeStatusCubit>().state.props.toString());
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: SizeConfig.blockSizeVertical * 90,
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  // primary: false,
                  // shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 50,
                      child: SizedMapWithRoutes(
                        latitudeStartPoint:
                            double.parse(widget.tripInfo.latitudeStartPoint!),
                        longitudeStartPoint:
                            double.parse(widget.tripInfo.longitudeStartPoint!),
                        latitudeEndPoint:
                            double.parse(widget.tripInfo.latitudeEndPoint!),
                        longitudeEndPoint:
                            double.parse(widget.tripInfo.longitudeEndPoint!),
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      margin: padding4,
                      color: const Color(0xFFF1F1F1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CachedImageWidget(
                                imageUrl: 'https://i.ibb.co/rF27hkX/user-1.png',
                                height: SizeConfig.blockSizeVertical * 5,
                                width: SizeConfig.blockSizeVertical * 5,
                                boxFit: BoxFit.cover,
                                borderRadius: 10,
                              ),
                              sizedBoxH5,
                              Text(
                                widget.tripInfo.clientName ?? '',
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.tripInfo.startName.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.tripInfo.endName.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                sizedBoxH5,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        sizedBoxW10,
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  kDefaultColor),
                            ),
                            onPressed: () {
                              context
                                  .read<ChangeStatusCubit>()
                                  .acceptTrip(widget.tripInfo.requestId, 1);
                              showNotifications(
                                  message:
                                      '${'you_accepted_offer'.tr} ${widget.tripInfo.tripPrice}',
                                  tripId: widget.tripInfo.requestId!);
                            },
                            child: Text(
                              '${'acceptFor'.tr} ${widget.tripInfo.tripPrice} ${'currency'.tr}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        sizedBoxW10,
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Container(
                              margin: padding8,
                              height: SizeConfig.blockSizeVertical * 3,
                              child: ClipRRect(
                                child: Image.asset(
                                  'assets/icons/google-maps.png',
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            onPressed: () {
                              openMapsSheet(context,
                                  startLong: double.parse(
                                      widget.tripInfo.longitudeStartPoint!),
                                  endLat: double.parse(
                                      widget.tripInfo.latitudeEndPoint!),
                                  endLong: double.parse(
                                      widget.tripInfo.longitudeEndPoint!),
                                  startLat: double.parse(
                                      widget.tripInfo.latitudeStartPoint!));
                            },
                            label: Text(
                              'showMap'.tr,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        sizedBoxW10,
                      ],
                    ),
                    sizedBoxH10,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'note'.tr,
                            style: const TextStyle(
                                color: kDefaultColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text(':'),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${widget.tripInfo.note}',
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'time'.tr,
                            style: const TextStyle(
                                color: kDefaultColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text(':'),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${widget.tripInfo.tripTime}',
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'distance'.tr,
                            style: const TextStyle(
                                color: kDefaultColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text(':'),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${widget.tripInfo.tripDistance}',
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    widget.tripInfo.image64 != null ||
                            widget.tripInfo.image != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('shipment_image'.tr),
                          )
                        : Container(),
                    widget.tripInfo.image64 != null
                        ? SizedBox(
                            height: SizeConfig.blockSizeVertical * 25,
                            child: Image.memory(
                              base64Decode(
                                widget.tripInfo.image64!,
                              ),
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(),
                    widget.tripInfo.image != null &&
                            widget.tripInfo.image!.isNotEmpty
                        ? SizedBox(
                            height: SizeConfig.blockSizeVertical * 25,
                            child: Image.network(
                              widget.tripInfo.image!,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'close'.tr,
                        style: const TextStyle(
                          color: kDefaultColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
