import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../logic_layer/ads_cubit/ads_cubit.dart';
import '../helpers/constants/constants.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({Key? key}) : super(key: key);

  @override
  State<BannerAds> createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  @override
  void initState() {
    context.read<AdsCubit>().getAds(type: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsState>(
      builder: (context, state) {
        log("ads state $state");
        if (state is AdsInitial) {
        } else if (state is AdsLoading) {
          return const SizedBox(
            // height: MediaQuery.of(context).size.height / 1.5,
            child: SpinKitWave(
              color: kDefaultColor,
              // size: 50.0,
            ),
          );
        } else if (state is AdsLoaded) {
          return CarouselSlider.builder(
            itemCount: state.data!.length,
            options: CarouselOptions(
              height: 400,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return Image.network(
                state.data![itemIndex].image!,
                fit: BoxFit.fitWidth,
              );
            },
          );
        } else if (state is AdsLoadingError) {
          return Container();
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
              )),
              child: Card(
                color: Colors.green[200],
                child: const Center(
                  child: Text('مساحة إعلانية',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
