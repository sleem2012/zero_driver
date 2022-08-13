import 'package:driver/logic_layer/upload_License/upload_license_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/document_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nations/nations.dart';

class UserLicense1Widget extends StatelessWidget {
  const UserLicense1Widget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadLicenseCubit, UploadLicenseState>(
      builder: (context, state) {
        final cubit = context.read<UploadLicenseCubit>();
        if (state is UploadLicenseInitial) {
          return InkWell(
            onTap: () {
              context.read<UploadLicenseCubit>().pickImage1(
                    context,
                  );
            },
            child: DocumentWidget(
              title: 'frontUserLicense'.tr,
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
                        context.read<UploadLicenseCubit>().pickImage1(
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
