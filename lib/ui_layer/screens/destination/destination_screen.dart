import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/logic_layer/destination/destination_cubit.dart';
import 'package:driver/ui_layer/screens/layout/layout_screen.dart';
import 'package:driver/ui_layer/widgets/picker/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../helpers/constants/constants.dart';
import 'package:nations/nations.dart';

import '../../widgets/picker/address_result.dart';
import '../../widgets/shared/overlay_loading.dart';
import '../blocked/blocked_screen.dart';

class DestinationScreen extends StatefulWidget {
  static const routeName = '/destination-screen';

  const DestinationScreen({Key? key}) : super(key: key);

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  final String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<CheckProfileCubit>().checkProfile();

    super.didChangeDependencies();
  }

  pickLocation() async {
    // LocationResult? result = await showLocationPicker(
    //   context,
    //   'AIzaSyAp4ttaDamsEiqnoGzWP1ulqBJ656lv4yk',
    //   initialCenter: const LatLng(31.1975844, 29.9598339),
    //   myLocationButtonEnabled: true,
    //   layersButtonEnabled: true,
    //   desiredAccuracy: LocationAccuracy.bestForNavigation,
    //   countries: ['EG'],
    //   language: 'ar',
    //   requiredGPS: false,
    //   automaticallyAnimateToCurrentLocation: true,
    // );
    // debugPrint("result = $result");
    // setState(() => _pickedLocation = result);
    AddressResult result = await showGoogleMapLocationPicker(

        pinWidget: const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 55,
        ),
        pinColor: Colors.blue,
        context: context,
        addressPlaceHolder: 'move_the_map'.tr,
        addressTitle: 'single_address'.tr,
        apiKey: 'AIzaSyAp4ttaDamsEiqnoGzWP1ulqBJ656lv4yk',
        appBarTitle: "حدد موقع التوصيل",
        confirmButtonColor: kDefaultColor,
        confirmButtonText: 'confirm_location'.tr,
        confirmButtonTextColor: Colors.white,
        country: "eg",
        language: "ar",
        searchHint: 'search_for_location'.tr,
        initialLocation: const LatLng(33.0515261234, 31.1952702387));

    context
        .read<DestinationCubit>()
        .sendDestination(result.latlng.latitude, result.latlng.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckProfileCubit, CheckProfileState>(
      listener: (context, state) {
        if (state is CheckProfileStateSuccess) {
          if (state.checkProfile.data!.susbended != 1) {
            Navigator.pushNamedAndRemoveUntil(
                context, BlockedScreen.routeName, (route) => false);
          }
        }
      },
      child: BlocListener<DestinationCubit, DestinationState>(
        listener: (context, state) {
          if (state is DestinationLoading) {
            showOverlayNotification(
              (context) {
                return const OverlayLoading();
              },
              position: NotificationPosition.bottom,
              key: const ValueKey('message'),
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, LayoutScreen.routeName, (route) => false);
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kDefaultColor,
              automaticallyImplyLeading: false,
              title: Text(
                'choose_destination'.tr,
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'destination_skip'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        kDefaultColor,
                      ),
                    ),
                    onPressed: () {
                      pickLocation();
                    },
                    child: Text(
                      "choose_destination".tr,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      context.read<DestinationCubit>().skipDestionation();
                    },
                    child: Text(
                      "skip".tr,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
