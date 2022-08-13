import 'package:driver/ui_layer/screens/splash_screen/splash_screen.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nations/nations.dart';

import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/logic_layer/trip_info/get_order_list_cubit.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/orders_list/order_list_bottom_sheet.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:page_transition/page_transition.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          print('printed');
          context.read<GetOrderListCubit>().getOrderList();
        },
        child: ListView(
          children: [
            BlocConsumer<GetOrderListCubit, GetOrderListState>(
              listener: (context, state) async {
                if (state is GetOrderListLoaded) {
                  if (state.tripsInfo.isNotEmpty) {
                    FlutterLocalNotificationsPlugin
                        flutterLocalNotificationsPlugin =
                        FlutterLocalNotificationsPlugin();
                    const AndroidInitializationSettings
                        initializationSettingsAndroid =
                        AndroidInitializationSettings(
                      'logo',
                    );
                    final IOSInitializationSettings initializationSettingsIOS =
                        IOSInitializationSettings(
                            onDidReceiveLocalNotification: (int i, String? val,
                                String? val2, String? val3) {});

                    final InitializationSettings initializationSettings =
                        InitializationSettings(
                      android: initializationSettingsAndroid,
                      iOS: initializationSettingsIOS,
                    );
                    await flutterLocalNotificationsPlugin
                        .initialize(initializationSettings,
                            onSelectNotification: (String? payload) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (Route<dynamic> route) => false);
                    });
                    await flutterLocalNotificationsPlugin
                        .initialize(initializationSettings,
                            onSelectNotification: (String? payload) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (Route<dynamic> route) => false);
                    });
                    AndroidNotificationDetails androidPlatformChannelSpecifics =
                        AndroidNotificationDetails(
                      '${state.tripsInfo[0].requestId}',
                      '${state.tripsInfo[0].requestId}',
                      channelDescription: '${state.tripsInfo[0].requestId}',
                      priority: Priority.max,
                      playSound: true,
                      importance: Importance.max,
                    );
                    NotificationDetails platformChannelSpecifics =
                        NotificationDetails(
                            android: androidPlatformChannelSpecifics);
                    await flutterLocalNotificationsPlugin.show(
                      0,
                      '${'trip_number'.tr}${state.tripsInfo[0].requestId}',
                      'from ${state.tripsInfo[0].startName} to ${state.tripsInfo[0].endName}',
                      platformChannelSpecifics,
                      payload: 'item x',
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is GetOrderListInitial) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 40,
                      ),
                      Center(
                        child: Text(
                          'noTrips'.tr,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GetOrderListCubit>().getOrderList();
                        },
                        child: Text(
                          'tapToRefresh'.tr,
                        ),
                      )
                    ],
                  );
                }
                if (state is GetOrderListLoading) {
                  return const LoadingWidget();
                }
                if (state is GetOrderListLoaded) {
                  if (state.tripsInfo.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 40,
                        ),
                        Center(
                          child: Text(
                            'noTrips'.tr,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print('printed');
                            context.read<GetOrderListCubit>().getOrderList();
                          },
                          child: Text(
                            'tapToRefresh'.tr,
                          ),
                        )
                      ],
                    );
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return NewlyOrderCard(
                        tripInfo: state.tripsInfo[index],
                      );
                    },
                    itemCount: state.tripsInfo.length,
                    shrinkWrap: true,
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewlyOrderCard extends StatelessWidget {
  final TripInfo tripInfo;
  const NewlyOrderCard({
    Key? key,
    required this.tripInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            alignment: Alignment.topCenter,
            child: OrderDetailsBottomSheet(
              tripInfo: tripInfo,
            ),
          ),
        );

        // showModalBottomSheet<void>(
        //   context: context,
        //   isScrollControlled: false,
        //   constraints: BoxConstraints(
        //     minHeight: SizeConfig.blockSizeVertical * 80,
        //     maxHeight: SizeConfig.blockSizeVertical * 80,
        //   ),
        //   builder: (BuildContext context) {
        //     return OrderDetailsBottomSheet(
        //       tripInfo: tripInfo,
        //     );
        //   },
        // );
        // showSimpleNotification(
        //     // Material(
        //     // child:
        //     OrderDetailsBottomSheet(
        //       tripInfo: tripInfo,
        //     ),
        //     // ),
        //     background: Colors.transparent,
        //     autoDismiss: false,
        //     position: NotificationPosition.bottom,
        //     key: const ValueKey('message'),
        //     contentPadding: const EdgeInsets.all(0),
        //     context: context);
      },
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          context.read<GetOrderListCubit>().removeTrip(tripInfo.requestId);
        },
        child: SizedBox(
          // height: SizeConfig.blockSizeVertical * 15,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 25,
                    child: Padding(
                      padding: padding4,
                      child: Column(
                        children: <Widget>[
                          CachedImageWidget(
                            imageUrl: 'https://i.ibb.co/rF27hkX/user-1.png',
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeVertical * 5,
                            boxFit: BoxFit.cover,
                            borderRadius: 10,
                          ),
                          Text(
                            tripInfo.clientName.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            tripInfo.date ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: padding4,
                    child: SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tripInfo.startName.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                          sizedBoxH5,
                          Text(
                            tripInfo.endName.toString(),
                          ),
                          sizedBoxH5,
                          Text(
                            '${tripInfo.tripPrice}${'currency'.tr}',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
