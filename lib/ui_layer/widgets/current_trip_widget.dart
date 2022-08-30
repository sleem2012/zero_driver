import 'package:dotted_line/dotted_line.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/logic_layer/change_status/change_status_cubit.dart';
import 'package:driver/logic_layer/start_or_finish/start_or_finish_cubit.dart';
import 'package:driver/logic_layer/trip_info/get_order_list_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/billing/billing_info_screen.dart';
import 'package:driver/ui_layer/screens/chat/chat_screen.dart';
import 'package:driver/ui_layer/screens/current_trip/current_trip_placeholder.dart';
import 'package:driver/ui_layer/screens/layout/layout_screen.dart';
import 'package:driver/ui_layer/widgets/map_with_routes.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/splash_screen/splash_screen.dart';

class CurrentTripWidget extends StatefulWidget {
  final TripInfo tripInfo;
  final String? time;
  final String? distance;
  const CurrentTripWidget({
    Key? key,
    required this.tripInfo,
    this.time,
    this.distance,
  }) : super(key: key);

  @override
  State<CurrentTripWidget> createState() => _CurrentTripWidgetState();
}

class _CurrentTripWidgetState extends State<CurrentTripWidget> {
  @override
  void initState() {
    context
        .read<StartOrFinishCubit>()
        .emitCancelTrip(widget.tripInfo.requestId);
    super.initState();
  }

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
      'your channel id_1',
      'your channel name_1',
      channelDescription: 'your channel description_1',
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
    return Container(
      padding: padding16,
      margin: padding16,
      width: SizeConfig.blockSizeHorizontal * 100,
      decoration: BoxDecoration(
        borderRadius: circular10,
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CachedImageWidget(
              imageUrl:
                  'https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg?size=338&ext=jpg',
              height: 50,
              width: 50,
              borderRadius: 50,
              boxFit: BoxFit.cover,
            ),
            title: Text(
              widget.tripInfo.clientName.toString(),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
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
                // InkWell(
                //   onTap: () {
                //     Navigator.pushNamed(context, ChatScreen.routeName,
                //         arguments: ChatParams(
                //             tripInfo: widget.tripInfo, driverName: "Driver"
                //             // getUserName()
                //             ));
                //   },
                //   child: Container(
                //     decoration: const BoxDecoration(
                //       color: kDefaultColor,
                //       shape: BoxShape.circle,
                //     ),
                //     margin: padding8,
                //     height: SizeConfig.blockSizeVertical * 7,
                //     width: SizeConfig.blockSizeHorizontal * 9,
                //     child: const ClipRRect(
                //       child: Icon(
                //         Icons.message,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    launch(
                        'https://api.whatsapp.com/send/?phone=${widget.tripInfo.clientMobile}');
                  },
                  child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.whatsapp),
                      )),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    openMapsSheet(context,
                        startLong:
                            double.parse(widget.tripInfo.longitudeEndPoint!),
                        endLat: double.parse(widget.tripInfo.latitudeEndPoint!),
                        endLong:
                            double.parse(widget.tripInfo.longitudeEndPoint!),
                        startLat:
                            double.parse(widget.tripInfo.latitudeEndPoint!));
                  },
                  child: Container(
                    margin: padding8,
                    height: SizeConfig.blockSizeVertical * 7,
                    width: SizeConfig.blockSizeHorizontal * 9,
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/icons/google-maps.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: kDefaultColor,
              ),
              sizedBoxW10,
              Expanded(
                child: Text(
                  widget.tripInfo.startName.toString(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 7,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: DottedLine(
                direction: Axis.vertical,
                lineThickness: 1.0,
                dashLength: 4.0,
                dashColor: Colors.black,
                dashRadius: 0.0,
                dashGapLength: 4.0,
                dashGapColor: Colors.transparent,
                dashGapRadius: 0.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                color: kDefaultColor,
              ),
              sizedBoxW10,
              Expanded(
                child: Text(
                  widget.tripInfo.endName.toString(),
                ),
              ),
            ],
          ),
          sizedBoxH5,
          const DottedLine(
            direction: Axis.horizontal,
          ),
          sizedBoxH5,
          Row(
            children: [
              Text(
                'price'.tr,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              sizedBoxW10,
              Text('${widget.tripInfo.tripPrice.toString()} ${'currency'.tr}'),
            ],
          ),
          Center(
            child: Text(
              widget.tripInfo.note ?? "",
            ),
          ),
          sizedBoxH10,
          BlocConsumer<StartOrFinishCubit, StartOrFinishState>(
            listener: (context, state) {
              if (state is StartOrFinishInitial) {
                context
                    .read<StartOrFinishCubit>()
                    .emitCancelTrip(widget.tripInfo.requestId);
              }
              if (state is CancelTripSuccess) {
                context.read<GetOrderListCubit>().getOrderList();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LayoutScreen(),
                    ),
                    (Route<dynamic> route) => false);
              }
              if (state is FinishTripSuccess) {
                showNotifications(
                    message: 'trip_has_ended'.tr,
                    tripId: widget.tripInfo.requestId!);
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        BillingInfoScreen(tripInfo: widget.tripInfo),
                  ),
                );
              }
              if (state is StartTripSuccess) {
                showNotifications(
                    message: 'trip_has_started'.tr,
                    tripId: widget.tripInfo.requestId!);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CurrentTripPlaceHolder()),
                    (Route<dynamic> route) => false);
              }
            },
            builder: (context, state) {
              if (state is StartOrFinishInitial) {
                return Row(
                  children: [
                    // Expanded(
                    //   child: DefaultButton(
                    //     height: SizeConfig.blockSizeVertical * 5,
                    //     width: SizeConfig.blockSizeHorizontal * 30,
                    //     text: 'startTrip'.tr,
                    //     background: kDefaultColor,
                    //     function: () {
                    //       context
                    //           .read<StartOrFinishCubit>()
                    //           .startTrip(widget.tripInfo.requestId);
                    //     },
                    //     titleColor: Colors.white,
                    //     fontSize: 18,
                    //     radius: 10,
                    //     toUpper: false,
                    //   ),
                    // ),
                    // sizedBoxW10,
                    Expanded(
                      child: DefaultButton(
                        height: SizeConfig.blockSizeVertical * 5,
                        width: SizeConfig.blockSizeHorizontal * 30,
                        text: 'arrived'.tr,
                        background: kDefaultColor,
                        function: () {
                          context
                              .read<StartOrFinishCubit>()
                              .arrived(widget.tripInfo.requestId);
                          showNotifications(
                              message: 'you_arrived'.tr,
                              tripId: widget.tripInfo.requestId!);
                        },
                        titleColor: Colors.white,
                        fontSize: 18,
                        radius: 10,
                        toUpper: false,
                      ),
                    ),
                  ],
                );
              }
              if (state is DriverArrivedSuccess) {
                //  "you_arrived": "Your arrived !",
                //                                     "trip_has_started": "Trip has started",
                //                                     "trip_has_ended": "Trip has finished"

                final startDate = getStartDate() != null
                    ? DateTime.parse(getStartDate().toString())
                    : DateTime.now();
                // DateTime.parse(getStartDate().toString()) ?? DateTime.now();
                final endDate = getEndDate() != null
                    ? DateTime.parse(getEndDate().toString())
                    : DateTime.now().add(const Duration(minutes: 5));
                var diff = endDate.difference(startDate);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('tillCancel'.tr),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: SlideCountdown(duration: diff),
                        ),
                      ],
                    ),
                    sizedBoxH10,
                    Row(
                      children: [
                        Expanded(
                          child: DefaultButton(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 30,
                            text: 'startTrip'.tr,
                            background: kDefaultColor,
                            function: () {
                              context
                                  .read<StartOrFinishCubit>()
                                  .startTrip(widget.tripInfo.requestId);
                            },
                            titleColor: Colors.white,
                            fontSize: 18,
                            radius: 10,
                            toUpper: false,
                          ),
                        ),
                        sizedBoxW10,
                        Expanded(
                          child: DefaultButton(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 30,
                            text: 'cancelTrip'.tr,
                            background: kDefaultColor,
                            function: () {
                              if (DateTime.now().isAfter(endDate)) {
                                showModalBottomSheet(
                                    isScrollControlled: false,
                                    context: context,
                                    builder: (builder) {
                                      return CancelTripWidget(
                                        tripInfo: widget.tripInfo,
                                      );
                                    });
                              }
                              if (DateTime.now().isBefore(endDate)) {
                                Fluttertoast.showToast(msg: 'noCancel'.tr);
                              }
                            },
                            titleColor: Colors.white,
                            fontSize: 18,
                            radius: 10,
                            toUpper: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              if (state is StartTripSuccess) {
                return DefaultButton(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  text: 'endTrip'.tr,
                  background: kDefaultColor,
                  function: () {
                    context
                        .read<ChangeStatusCubit>()
                        .finish(widget.tripInfo.requestId, 4);
                    context
                        .read<StartOrFinishCubit>()
                        .finishTrip(widget.tripInfo.requestId);
                  },
                  titleColor: Colors.white,
                  fontSize: 18,
                  radius: 10,
                  toUpper: false,
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }
}

class CancelTripWidget extends StatefulWidget {
  final TripInfo? tripInfo;
  const CancelTripWidget({
    Key? key,
    required this.tripInfo,
  }) : super(key: key);

  @override
  _CancelTripWidgetState createState() => _CancelTripWidgetState();
}

class _CancelTripWidgetState extends State<CancelTripWidget> {
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        sizedBoxH10,
        Text('cancelCause'.tr),
        Padding(
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: TextFormField(
            controller: noteController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: DefaultButton(
            background: kDefaultColor,
            fontSize: 18,
            function: () {
              context.read<StartOrFinishCubit>().cancelTrip(
                    noteController.text,
                    widget.tripInfo!,
                    // TripInfo()
                  );
              removeStartDate();
              removeEndDate();
              context.read<GetOrderListCubit>().getOrderList();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LayoutScreen(),
                  ),
                  (Route<dynamic> route) => false);
            },
            height: SizeConfig.blockSizeVertical * 7,
            radius: 10,
            text: 'cancelTrip'.tr,
            toUpper: false,
            titleColor: Colors.white,
            width: SizeConfig.blockSizeHorizontal * 100,
          ),
        ),
      ],
    );
  }
}

class ChatParams {
  final TripInfo tripInfo;
  final String? driverName;
  ChatParams({
    required this.tripInfo,
    this.driverName,
  });
}
