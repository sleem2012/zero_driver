import 'dart:developer';

import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/current_trip/current_trip_placeholder.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:nations/nations.dart';

import '../../../logic_layer/check_profile/check_profile_cubit.dart';

class PermissionScreen extends StatefulWidget {
  static const routeName = '/permission';

  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getPermission();
    });
  }

  getPermission() async {
    Location location = Location();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.8),
        content: Text(
            "permissionMessage".tr,style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("deny".tr,)),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                bool serviceEnabled;
                PermissionStatus permissionGranted;
                LocationData locationData;

                permissionGranted = await location.hasPermission();
                if (permissionGranted == PermissionStatus.denied) {
                  permissionGranted = await location.requestPermission();
                  if (permissionGranted != PermissionStatus.granted) {
                    return;
                  }
                }
              },
              child: Text("accept".tr)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'grantAccess'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mcLaren(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/map.jpg',
              ),
            ],
          )),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultButton(
          toUpper: false,
          background: kDefaultColor,
          fontSize: 18,
          function: () async {
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

            permissionGranted = await location.hasPermission();
            if (permissionGranted == PermissionStatus.denied) {
              permissionGranted = await location.requestPermission();
              if (permissionGranted != PermissionStatus.granted) {
                return;
              }
            }

            Navigator.pushReplacementNamed(context, CurrentTripPlaceHolder.routeName);
          },
          height: SizeConfig.blockSizeVertical * 7,
          radius: 10,
          text: "allow".tr,
          titleColor: Colors.white,
          width: SizeConfig.blockSizeHorizontal * 100,
        ),
      ),
    );
  }

  @override
  void dispose() {
    context.read<CheckProfileCubit>().checkProfile();
    log("message check profile");
    super.dispose();
  }
}
