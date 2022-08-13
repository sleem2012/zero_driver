import 'dart:developer';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nations/nations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../logic_layer/ads_cubit/ads_cubit.dart';
import '../login/login_screen.dart';

class WelcomeAds extends StatefulWidget {
  static const String routeName = '/welcomeAds';
  const WelcomeAds({Key? key}) : super(key: key);

  @override
  State<WelcomeAds> createState() => _WelcomeAdsState();
}

class _WelcomeAdsState extends State<WelcomeAds> {
  @override
  void initState() {
    context.read<AdsCubit>().getAds(type: 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            Text(
              'welcome_zero'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            BlocBuilder<AdsCubit, AdsState>(
              builder: (context, state) {
                log('ads state $state');
                if (state is AdsLoading) {
                  return const Expanded(
                    child: SpinKitWave(
                      color: kDefaultColor,
                      // size: 50.0,
                    ),
                  );
                }
                if (state is AdsLoaded) {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(state.data![0].image!),
                  ));
                }
                if (state is AdsLoadingError) {
                  return Text(state.error);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.scale,
              duration: const Duration(seconds: 1),
              alignment: Alignment.topCenter,
              child: const LoginScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(
            10.0,
          ),
          margin: const EdgeInsets.all(
            10.0,
          ),
          color: kDefaultColor,
          child: Text(
            "next".tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
