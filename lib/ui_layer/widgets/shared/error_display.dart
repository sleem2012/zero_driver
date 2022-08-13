import 'package:flutter/material.dart';

import 'package:driver/ui_layer/helpers/size_config/size_config.dart';

/// widget that display error message
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    Key? key,
    required this.errorMessage,
    required this.width,
  }) : super(key: key);

  /// message to display
  final String errorMessage;

  /// widget width

  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: SizeConfig.blockSizeVertical * height,
      width: SizeConfig.blockSizeHorizontal * width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/404.png',
          ),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
