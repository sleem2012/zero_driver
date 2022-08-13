import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

///  Widget that shows
/// loading indicator while loading
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.height, required this.width})
      : super(key: key);

  /// widget height
  final double height;

  /// widget width
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * width,
      height: SizeConfig.blockSizeVertical * height,
      child: const SpinKitWave(
        color: kDefaultColor,
        size: 50.0,
      ),
    );
  }
}
