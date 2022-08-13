import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OverlayLoading extends StatelessWidget {
  const OverlayLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
