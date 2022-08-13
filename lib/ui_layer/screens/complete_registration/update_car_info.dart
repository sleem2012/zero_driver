import 'dart:developer';

import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/logic_layer/get_models/get_models_cubit.dart';
import 'package:driver/logic_layer/update_car_information/update_car_information_cubit.dart';
import 'package:driver/logic_layer/upload_car_license/upload_car_license_cubit.dart';
import 'package:driver/ui_layer/widgets/complete_registration.dart/car_license1.dart';
import 'package:driver/ui_layer/widgets/complete_registration.dart/car_license2.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:nations/nations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:driver/logic_layer/cars_info/cars_info_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:driver/injection_container.dart' as di;

class UpdateCarInfo extends StatefulWidget {
  static const routeName = '/car-info';
  const UpdateCarInfo({Key? key}) : super(key: key);

  @override
  State<UpdateCarInfo> createState() => _UpdateCarInfoState();
}

class _UpdateCarInfoState extends State<UpdateCarInfo> {
  int carService = 1;
  String carModel = '';
  String carColor = '';
  String carYear = '';
  String carColorString = '';
  String carModelString = '';
  String carServiceString = '';

  final _formKey = GlobalKey<FormState>();

  TextEditingController carNumberController = TextEditingController();
  @override
  void dispose() {
    carNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CarsInfoCubit>()..getCarsInfo(),
        ),
        BlocProvider(
          create: (context) => UpdateCarInformationCubit(),
        ),
        BlocProvider(
          create: (context) => UploadCarLicenseCubit(),
        ),
        BlocProvider(
          create: (context) => GetModelsCubit(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'updateCarInfo'.tr,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<CarsInfoCubit, CarsInfoState>(
          builder: (context, state) {
            if (state is CarsInfoStateLoading) {
              return const LoadingWidget();
            }
            if (state is CarsInfoStateSuccess) {
              final List<String> listOfService = state.carsInfo.data!.service
                  .map((service) => service.name)
                  .toList();

              final cubit = context.read<CarsInfoCubit>();
              print(cubit.carColorString.isNotEmpty &&
                  cubit.carModelString.isNotEmpty &&
                  cubit.carServiceString.isNotEmpty &&
                  cubit.carYear.isNotEmpty);
              print('cubit.carColorString ${cubit.carColorString}d');
              print('cubit.carModelString ${cubit.carModelString} d');
              print('cubit.carServiceString ${cubit.carServiceString} d');
              print('cubit.carYear ${cubit.carYear} d');
              return ConditionalBuilder(
                condition: cubit.carColorString.isNotEmpty &&
                    cubit.carModelString.isNotEmpty &&
                    cubit.carServiceString.isNotEmpty &&
                    cubit.carYear.isNotEmpty,
                builder: (context) => Form(
                  key: _formKey,
                  child: Container(
                    color: const Color(0xFFE5E5E5),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: padding16,
                          padding: padding16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    'carType'.tr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  sizedBoxW10,
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        focusColor: kDefaultColor,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: kDefaultColor,
                                        ),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: kDefaultColor,
                                            fontWeight: FontWeight.bold),
                                        // value: cubit.carServiceString,
                                        value: cubit.carServiceString,
                                        onChanged: (newValue) {
                                          setState(() {
                                            cubit.carServiceString = newValue!;
                                            carService = state
                                                .carsInfo.data!.service
                                                .firstWhere((element) =>
                                                    element.name == newValue)
                                                .id;
                                          });
                                          carServiceString = newValue!;

                                          context
                                              .read<GetModelsCubit>()
                                              .getGetModels(carService);
                                        },
                                        items: listOfService
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              sizedBoxH5,
                              BlocBuilder(
                                bloc: BlocProvider.of<GetModelsCubit>(context),
                                builder: ((context, state) {
                                  final modelsCubit =
                                      context.read<GetModelsCubit>();
                                  log('state $state');
                                  if (state is GetModelsStateLoading) {
                                    return const LoadingWidget();
                                  }
                                  if (state is GetModelsStateSuccess) {
                                    final List<String> listOfColors = state
                                        .carsModelInfo.data!.carColor
                                        .map((color) => color.name)
                                        .toList();
                                    final List<String> listOfModels = state
                                        .carsModelInfo.data!.carModel
                                        .map((e) => e.name)
                                        .toList();
                                    return Column(
                                      children: [
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'carModel'.tr + carServiceString,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            sizedBoxW10,
                                            Expanded(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  focusColor: kDefaultColor,
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: kDefaultColor,
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: kDefaultColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  value: modelsCubit
                                                      .carModelString,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      modelsCubit
                                                              .carModelString =
                                                          newValue!;
                                                    });
                                                    carModel = state
                                                        .carsModelInfo
                                                        .data!
                                                        .carModel
                                                        .firstWhere((element) =>
                                                            element.name ==
                                                            newValue)
                                                        .id
                                                        .toString();
                                                    carModelString = newValue!;
                                                  },
                                                  items: listOfModels.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizedBoxH5,
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'carColor'.tr + carServiceString,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            sizedBoxW10,
                                            Expanded(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  focusColor: kDefaultColor,
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: kDefaultColor,
                                                  ),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: kDefaultColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  value: modelsCubit
                                                      .carColorString,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      modelsCubit
                                                              .carColorString =
                                                          newValue!;
                                                      carColor = state
                                                          .carsModelInfo
                                                          .data!
                                                          .carColor
                                                          .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .name ==
                                                                  newValue)
                                                          .id
                                                          .toString();
                                                    });
                                                    carColorString = newValue!;
                                                  },
                                                  items: listOfColors.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizedBoxH5,
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        sizedBoxH5,
                                        Row(
                                          children: [
                                            Text(
                                              'carYear'.tr,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            sizedBoxW10,
                                            Expanded(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  focusColor: kDefaultColor,
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: kDefaultColor,
                                                  ),

                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: kDefaultColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  value: modelsCubit.carYear,
                                                  // value: state.carsInfo.data!.carYear[0],
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      modelsCubit.carYear =
                                                          newValue!;
                                                      carYear = state
                                                          .carsModelInfo
                                                          .data!
                                                          .carYear
                                                          .firstWhere(
                                                              (element) =>
                                                                  element ==
                                                                  newValue)
                                                          .toString();
                                                    });
                                                  },
                                                  items: state.carsModelInfo
                                                      .data!.carYear
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        sizedBoxH5,
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        sizedBoxH5,
                                      ],
                                    );
                                  }
                                  return Container();
                                }),
                              )
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
                                'carNumber'.tr + carServiceString,
                              ),
                              sizedBoxH5,
                              TextFormField(
                                validator: (String? val) => val!.isEmpty
                                    ? 'Enter your Car number'
                                    : null,
                                controller: carNumberController,
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
                        CarLicense1Widget(carLicense: carServiceString),
                        CarLicense2Widget(carLicense: carServiceString),
                        BlocListener<UpdateCarInformationCubit,
                            UpdateCarInformationState>(
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultButton(
                              background: kDefaultColor,
                              fontSize: 18,
                              function: () {
                                final currentState = _formKey.currentState;
                                if (!currentState!.validate()) {}
                                if (carModel.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'من فضلك اختر موديل السيارة');
                                }
                                if (carColor.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'من فضلك اختر لون السيارة');
                                }
                                if (carYear.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'من فضلك اختر سنة السيارة');
                                }
                                if (context
                                        .read<UploadCarLicenseCubit>()
                                        .image1
                                        .path
                                        .isEmpty ||
                                    context
                                        .read<UploadCarLicenseCubit>()
                                        .image2
                                        .path
                                        .isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'من فضلك اختر صورة رخصة السيارة');
                                }
                                if (carModel.isNotEmpty &&
                                    carColor.isNotEmpty &&
                                    carYear.isNotEmpty &&
                                    currentState.validate() &&
                                    context
                                        .read<UploadCarLicenseCubit>()
                                        .image1
                                        .path
                                        .isNotEmpty &&
                                    context
                                        .read<UploadCarLicenseCubit>()
                                        .image2
                                        .path
                                        .isNotEmpty) {
                                  final cubit =
                                      context.read<UploadCarLicenseCubit>();
                                  context
                                      .read<UpdateCarInformationCubit>()
                                      .updateCarInfo(
                                        carColorString: carColorString,
                                        carModelString: carModelString,
                                        carModel: int.parse(carModel),
                                        serviceType: carService,
                                        carYear: carYear,
                                        carColor: int.parse(carColor),
                                        carNumber: carNumberController.text,
                                        frondSide: cubit.image1,
                                        backSide: cubit.image2,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                fallback: (context) => const Center(child: LoadingWidget()),
              );
            }
            if (state is CarsInfoStateError) {
              return Center(
                child: Text(state.error),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
