import 'dart:async';

import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/check_profile/check_profile.dart';
import 'package:driver/logic_layer/change_availability/change_availabilty_cubit.dart';
import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';

import 'package:driver/logic_layer/trip_info/get_order_list_cubit.dart';
import 'package:driver/logic_layer/user_info/user_info_cubit.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/complete_registration/complete_registeration.dart';
import 'package:driver/ui_layer/widgets/map_with_routes.dart';
import 'package:driver/ui_layer/widgets/shared/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:nations/nations.dart';
import 'package:driver/logic_layer/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/injection_container.dart' as di;
import 'package:socket_io_client/socket_io_client.dart';

import '../../widgets/banner_ads.dart';

class LayoutScreen extends StatefulWidget {
  static const routeName = '/layout-screen';

  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocationData? _location;
  double? latitude;
  double? longitude;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  bool isSent = true;
  @override
  void initState() {
    // context.read<ChangeAvailabilityCubit>().changeAvailability(false);
    // context.read<GetOrderListCubit>().getOrderList();
    context.read<CheckProfileCubit>().checkProfile();
    context.read<UserInfoCubit>().getUserInfo();
    getPermission();
    _listenLocation();
    super.initState();
  }

  // socket.emit(
  //   'update_location',
  //   {"id": 55, "lng": 33.5, "lat": 35.5},
  // );

  final Location location = Location();
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
        Future.delayed(const Duration(seconds: 5))
            .then((value) => di.sl<Socket>().emit(
                  'update_location',
                  {
                    "id": getUserId(),
                    "lng": _location!.longitude,
                    "lat": _location!.latitude,
                    "time": DateTime.now().toString()
                  },
                ));
      }

      isSent = false;
      if (longitude != null &&
          latitude != null &&
          double.parse(
                _location!.longitude!.toStringAsFixed(3),
              ) !=
              longitude &&
          double.parse(
                _location!.latitude!.toStringAsFixed(3),
              ) !=
              latitude) {
        print('update_location');
        di.sl<Socket>().emit(
          'update_location',
          {
            "id": getUserId(),
            "lng": _location!.longitude,
            "lat": _location!.latitude,
            "time": DateTime.now().toString()
          },
        );
      }
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription?.cancel();

    _locationSubscription = null;
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();

    _locationSubscription = null;
    super.dispose();
  }

  getPermission() {
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
    });
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'exit_warning'.tr);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                BottomNavBarCubit()..emit(BottomNavBarInitial()),
          ),
        ],
        child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
          builder: (context, state) {
            final cubit = context.read<BottomNavBarCubit>();
            return Scaffold(
              key: _scaffoldKey,
              drawer: const CustomDrawer(),
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: kDefaultColor,
                  ),
                ),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: BlocBuilder<ChangeAvailabilityCubit,
                    ChangeAvailabiltyState>(
                  builder: (context, state) {
                    if (state is ChangeAvailabiltyLoading) {
                      return const CircularProgressIndicator();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoSwitch(
                          value:
                              context.read<ChangeAvailabilityCubit>().isOnline,
                          onChanged: (value) async {
                            await context
                                .read<CheckProfileCubit>()
                                .checkProfile();
                            final CheckProfile checkProfile = context
                                .read<CheckProfileCubit>()
                                .checkProfileModel;
                            if (checkProfile.data!.backSideCarLicense &&
                                checkProfile.data!.frontSideCarLicense &&
                                checkProfile.data!.carColor &&
                                checkProfile.data!.carYear &&
                                checkProfile.data!.frontSideLicense &&
                                checkProfile.data!.backSideLicense) {
                              context
                                  .read<ChangeAvailabilityCubit>()
                                  .changeAvailability(value);
                              if (value) {
                                context
                                    .read<GetOrderListCubit>()
                                    .getOrderList();
                              }
                            } else if (!checkProfile.data!.backSideCarLicense ||
                                !checkProfile.data!.frontSideCarLicense ||
                                !checkProfile.data!.carColor ||
                                !checkProfile.data!.carYear ||
                                !checkProfile.data!.frontSideLicense ||
                                !checkProfile.data!.backSideLicense) {
                              _showMyDialog(context);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                centerTitle: true,
              ),
              body: cubit.widgetOptions[cubit.currentIndex],
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomNavigationBar(
                    type: BottomNavigationBarType.shifting,
                    selectedItemColor: kDefaultColor,
                    unselectedItemColor: Colors.grey,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: const Icon(
                          FontAwesomeIcons.list,
                        ),
                        label: 'ordersList'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(
                          FontAwesomeIcons.moneyBill,
                        ),
                        label: 'tripHistory'.tr,
                      ),
                    ],
                    currentIndex:
                        context.read<BottomNavBarCubit>().currentIndex,
                    onTap: (int index) {
                      context.read<BottomNavBarCubit>().changeIndex(index);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 7,
                    width: SizeConfig.blockSizeHorizontal * 100,
                    child: const Card(child: BannerAds()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Text('mustCompleteRegis'.tr),

        actions: <Widget>[
          TextButton(
            child: Text('accept'.tr),
            onPressed: () {
              Navigator.pushNamed(context, CompleteRegisteration.routeName);
            },
          ),
          TextButton(
            child: Text('close'.tr),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
