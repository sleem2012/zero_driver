import 'package:flutter/material.dart';
import 'package:nations/nations.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';

class DocumentWidget extends StatelessWidget {
  final String title;
  const DocumentWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: padding16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: circular10,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          sizedBoxH10,
          Image.network(
            'https://i.ibb.co/6rjs5J5/driver-license.png',
            height: SizeConfig.blockSizeVertical * 20,
          ),
          sizedBoxH5,
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kDefaultColor,
              ),
              borderRadius: circular10,
            ),
            child: DefaultButton(
              toUpper: true,
              background: Colors.white,
              fontSize: 16,
              titleColor: kDefaultColor,
              function: null,
              height: SizeConfig.blockSizeVertical * 7,
              width: SizeConfig.blockSizeHorizontal * 30,
              text: "upload".tr,
              radius: 10,
            ),
          ),
        ],
      ),
    );
  }
}
