import 'package:driver/logic_layer/upload_complete_data/upload_complete_data_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nations/nations.dart';
import '../document_widget.dart';

class CompleteData5Widget extends StatelessWidget {
  const CompleteData5Widget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadCompleteDataCubit, UploadCompleteDataState>(
      builder: (context, state) {
        final cubit = context.read<UploadCompleteDataCubit>();
        if (state is UploadCompleteDataInitial) {
          return InkWell(
            onTap: () {
              context.read<UploadCompleteDataCubit>().pickImage5(
                    context,
                  );
            },
            child: DocumentWidget(
              title: 'drug_test'.tr,
            ),
            //             "criminal_records":"الفيش الجنائي",
            // "personal_id":"البطاقة الشخصية",
            // "car_plate":"صورة السيارة باللوحة"
          );
        }
        if (state is UploadLicenseSuccess &&
            cubit.image5 != null &&
            cubit.image5.path.isNotEmpty) {
          return SizedBox(
            height: SizeConfig.blockSizeVertical * 40,
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 30,
                    child: Image.file(
                      cubit.image5,
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
                        context.read<UploadCompleteDataCubit>().pickImage5(
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
        return InkWell(
          onTap: () {
            context.read<UploadCompleteDataCubit>().pickImage5(
                  context,
                );
          },
          child: DocumentWidget(
            title: 'drug_test'.tr,
          ),
          //             "criminal_records":"الفيش الجنائي",
          // "personal_id":"البطاقة الشخصية",
          // "car_plate":"صورة السيارة باللوحة"
        );
        // return Container();
      },
    );
  }
}
