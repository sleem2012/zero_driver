import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/logic_layer/complete_data/complete_data_cubit.dart';
import 'package:driver/logic_layer/upload_complete_data/upload_complete_data_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/complete_data/complete_data1.dart';
import 'package:driver/ui_layer/widgets/complete_data/complete_data2.dart';
import 'package:driver/ui_layer/widgets/complete_data/complete_data3.dart';
import 'package:driver/ui_layer/widgets/complete_data/complete_data4.dart';
import 'package:driver/ui_layer/widgets/complete_data/complete_data5.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

class CompleteData extends StatefulWidget {
  static const routeName = '/complete-data';

  const CompleteData({Key? key}) : super(key: key);

  @override
  _CompleteDataState createState() => _CompleteDataState();
}

class _CompleteDataState extends State<CompleteData> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CompleteDataCubit(),
        ),
        BlocProvider(
          create: (context) => UploadCompleteDataCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            'completeData'.tr,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: ListView(
          children: [
            const CompleteData1Widget(),
            const CompleteData2Widget(),
            const CompleteData3Widget(),
            //const CompleteData4Widget(),
            //const CompleteData5Widget(),
            BlocListener<CompleteDataCubit, CompleteDataState>(
              listener: (context, state) {
                if (state is CompleteDataStateLoading) {
                  showOverlayNotification(
                    (context) {
                      return const OverlayLoading();
                    },
                    position: NotificationPosition.bottom,
                    key: const ValueKey('message'),
                  );
                }
                if (state is CompleteDataStateSuccess) {
                  context.read<CheckProfileCubit>().checkProfile();
                  Fluttertoast.showToast(msg: 'Done');
                  Navigator.pop(context);
                }
                if (state is CompleteDataStateError) {
                  Fluttertoast.showToast(msg: state.error);
                }
              },
              child: BlocBuilder<UploadCompleteDataCubit, UploadCompleteDataState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultButton(
                      background: kDefaultColor,
                      fontSize: 18,
                      function: () {
                        if (context.read<UploadCompleteDataCubit>().image1.path.isEmpty ||
                            context.read<UploadCompleteDataCubit>().image2.path.isEmpty) {
                          Fluttertoast.showToast(msg: 'personal_id_empty'.tr);
                        }
                        if (context.read<UploadCompleteDataCubit>().image3.path.isEmpty) {
                          Fluttertoast.showToast(msg: 'car_plate_empty'.tr);
                        }

                        if (context.read<UploadCompleteDataCubit>().image1.path.isNotEmpty &&
                            context.read<UploadCompleteDataCubit>().image2.path.isNotEmpty) {
                          final cubit = context.read<UploadCompleteDataCubit>();
                          context.read<CompleteDataCubit>().completeData(
                                personalIdFront: cubit.image1,
                                personalIdBack: cubit.image2,
                                carPlate: cubit.image3,
                              );
                        }
                      },
                      height: SizeConfig.blockSizeVertical * 7,
                      radius: 10,
                      text: 'update'.tr,
                      titleColor: Colors.white,
                      toUpper: false,
                      width: SizeConfig.blockSizeHorizontal * 100,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}