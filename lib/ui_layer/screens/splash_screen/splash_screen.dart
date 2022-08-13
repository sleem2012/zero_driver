import 'dart:async';
import 'dart:developer';

import 'package:driver/ui_layer/screens/welcome_ads/welcome_ads.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/injection_container.dart' as di;
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/permission/permission_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    di.sl<Socket>().connect();
    di.sl<Socket>().onConnect((_) {
      print('connect');
      log('connect socket');
      //  di.sl<Socket>().emit('msg', 'test');
    });
    di.sl<Socket>().onConnectError((data) => log('connect error $data'));
    if (getUserStatus() == null) {
      saveUserStatus(false);
    }
    checkUser();
    // Timer(
    //   const Duration(seconds: 3),
    //   () => Navigator.pushNamed(
    //     context,
    //     '/otp',
    //   ),
    // );
  }

  checkUser() async {
    String? token = getUserToken();

    if (token != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 1500),
            type: PageTransitionType.rotate,
            alignment: Alignment.topCenter,
            child: const PermissionScreen(),
          ),
        );
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 1500),
            type: PageTransitionType.rotate,
            alignment: Alignment.topCenter,
            child: const WelcomeAds(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Hero(
            tag: 'splash',
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
