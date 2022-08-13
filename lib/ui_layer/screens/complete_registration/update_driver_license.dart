import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/logic_layer/update_license_info/update_license_info_cubit.dart';
import 'package:driver/logic_layer/upload_License/upload_license_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/complete_registration.dart/user_lcense1.dart';
import 'package:driver/ui_layer/widgets/complete_registration.dart/user_license2.dart';
import 'package:driver/ui_layer/widgets/document_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:nations/nations.dart';

class UpdateDriverLicense extends StatefulWidget {
  static const routeName = '/driver-license';
  const UpdateDriverLicense({Key? key}) : super(key: key);

  @override
  State<UpdateDriverLicense> createState() => _UpdateDriverLicenseState();
}

class _UpdateDriverLicenseState extends State<UpdateDriverLicense> {
  TextEditingController expireDateController = TextEditingController();
  TextEditingController licenseNumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    expireDateController.dispose();
    licenseNumController.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 20),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('yyyy-MM-dd');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UploadLicenseCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateLicenseInfoCubit(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'updateDriverLicense'.tr,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: const Color(0xFFE5E5E5),
            child: ListView(
              children: <Widget>[
                const UserLicense1Widget(),
                // sizedBoxH10,
                const UserLicense2Widget(),
                // sizedBoxH10,
                Container(
                  margin: padding16,
                  padding: padding16,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'expireDate'.tr,
                      ),
                      sizedBoxH5,
                      ElevatedButton(
                        onPressed: () {
                          print(format.format(selectedDate));
                          print(selectedDate);
                          _selectDate(context);
                        },
                        child: Text(
                          format.format(selectedDate),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: padding16,
                  padding: padding16,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'licenseNumber'.tr,
                      ),
                      sizedBoxH5,
                      TextFormField(
                        validator: (value) {
                          if(value!.isEmpty){
                             return  "emptyField".tr ;
                          }
                          if(value.length < 14){
                            return  '14 digit' ;
                          }
                        },
                        controller: licenseNumController,
                        decoration: InputDecoration(
                          contentPadding: padding16,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocListener<UpdateLicenseInfoCubit, UpdateLicenseInfoState>(
                  listener: (context, state) {
                    if (state is UpdateCarInformationLoading) {
                      showOverlayNotification(
                        (context) {
                          return const OverlayLoading();
                        },
                        position: NotificationPosition.bottom,
                        key: const ValueKey('message'),
                      );
                    }
                    if (state is UpdateCarInformationSuccess) {
                      context.read<CheckProfileCubit>().checkProfile();
                      Fluttertoast.showToast(msg: 'Done');
                      Navigator.pop(context);
                    }
                    if (state is UpdateCarInformationError) {
                      Fluttertoast.showToast(msg: state.error);
                    }
                  },
                  child: BlocBuilder<UploadLicenseCubit, UploadLicenseState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultButton(
                          background: kDefaultColor,
                          fontSize: 18,
                          function: () {
                            print(format.format(selectedDate));

                            final currentState = _formKey.currentState;
                            if (!currentState!.validate()) {}

                            if (context.read<UploadLicenseCubit>().image1.path.isEmpty ||
                                context.read<UploadLicenseCubit>().image2.path.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Upload License Image');
                            }
                            if (currentState.validate() && context.read<UploadLicenseCubit>().image1.path.isNotEmpty &&
                                context.read<UploadLicenseCubit>().image2.path.isNotEmpty) {
                              print('done object');
                              print(format.format(selectedDate));
                              final cubit = context.read<UploadLicenseCubit>();
                              context.read<UpdateLicenseInfoCubit>().updateUserInfo(expiryDate: format.format(selectedDate).replaceAll('/', '-'), licenseNumber: licenseNumController.text, frondSide: cubit.image1, backSide: cubit.image2);
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
        ),
      ),
    );
  }
}
