import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nations/nations.dart';

import 'package:driver/logic_layer/upload_car_license/upload_car_license_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/document_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';

class CarLicense1Widget extends StatelessWidget {
  final String carLicense;
  const CarLicense1Widget({
    Key? key,
    required this.carLicense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadCarLicenseCubit, UploadCarLicenseState>(
      builder: (context, state) {
        final cubit = context.read<UploadCarLicenseCubit>();
        if (state is UploadCarLicenseInitial) {
          return InkWell(
            onTap: () {
              context.read<UploadCarLicenseCubit>().pickImage1(
                    context,
                  );
            },
            child: DocumentWidget(
              title: 'frontCarLicense'.tr + carLicense,
            ),
          );
        }
        if (state is UploadLicenseSuccess && cubit.image1 != null) {
          return SizedBox(
            height: SizeConfig.blockSizeVertical * 40,
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 30,
                    child: Image.file(
                      cubit.image1,
                      fit: BoxFit.cover,
                    ),
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
                      function: () {
                        context.read<UploadCarLicenseCubit>().pickImage1(
                              context,
                            );
                      },
                      height: SizeConfig.blockSizeVertical * 7,
                      width: SizeConfig.blockSizeHorizontal * 30,
                      text: "upload".tr,
                      radius: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
