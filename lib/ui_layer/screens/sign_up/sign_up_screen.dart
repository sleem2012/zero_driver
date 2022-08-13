import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/logic_layer/sign_up/sign_up_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/login/login_screen.dart';
import 'package:driver/ui_layer/screens/permission/permission_screen.dart';
import 'package:driver/ui_layer/widgets/shared/build_login_text_box.dart';
import 'package:driver/ui_layer/widgets/shared/custom_text_field/custom_TextField_without_icon.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:overlay_support/overlay_support.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController mobileController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController codeController = TextEditingController();
  String countryCode = '';
  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit()..emit(SignUpInitial()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Center(
                child: Container(
                  // width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/logo_wi.png'),
                    fit: BoxFit.fitHeight,
                  )),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Rectangle_login.png'),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 12,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(70)),
                            //color: Colors.black,
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Center(
                                child: Text(
                                  'register'.tr,
                                  style: const TextStyle(
                                    color: Color(0xff212A37),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                '${'enter'.tr} ${'name'.tr}',
                                style: const TextStyle(
                                  color: Color(0xff212A37),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 70,
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 10,
                                child: BuildLoginSignUpTextBox(
                                  obsecureText: false,
                                  hintLabel: 'name'.tr,
                                  controller: nameController,
                                  textInputType: TextInputType.name,
                                  validator: (String? value) =>
                                      value!.isEmpty ? 'emptyField'.tr : null,
                                  function: () {
                                    nameController.clear();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),
                              Text(
                                '${'enter'.tr} ${'yourNumber'.tr}',
                                style: const TextStyle(
                                  color: Color(0xff212A37),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 70,
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  width: double.infinity,
                                  height: SizeConfig.blockSizeVertical * 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      CountryCodePicker(
                                        onChanged: (code) {
                                          countryCode='${code.dialCode}';
                                        },
                                        onInit: (code) {
                                          countryCode='$code';
                                        },
                                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                        initialSelection: 'EG',
                                        favorite: ['+20', 'مصر'],
                                        padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: false,
                                      ),

                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 18.0),
                                          child: CustomTextFieldWithoutIcon(
                                            textInputAction:
                                            TextInputAction.next,
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'emptyField'.tr;
                                              }
                                              if (mobileController.text[0] ==
                                                  '0') {
                                                return "can'tWith0".tr;
                                              }
                                              if (value.length < 10) {
                                                return 'lessThan10'.tr;
                                              }
                                            },
                                            controller: mobileController,
                                            hintLabel: '0123456789',
                                            textInputType: TextInputType.phone,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          mobileController.clear();
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            //    color: Colors.blue,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/icons/clear_icon.png'),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),
                              Text(
                                '${'enter'.tr} ${'passwordLabel'.tr}',
                                style: const TextStyle(
                                  color: Color(0xff212A37),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 70,
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: SizedBox(
                                  height: SizeConfig.blockSizeVertical * 10,
                                  child: BuildLoginSignUpTextBox(
                                    obsecureText: true,
                                    hintLabel: '******',
                                    controller: passwordController,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'emptyField'.tr;
                                      }

                                      if (value.length < 6) {
                                        return 'passwordLess6'.tr;
                                      }
                                      return null;
                                    },
                                    function: () {
                                      passwordController.clear();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),
                              Text(
                                '${'enter'.tr} ${'passwordLabel'.tr}',
                                style: const TextStyle(
                                  color: Color(0xff212A37),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 70,
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 10,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: BuildLoginSignUpTextBox(
                                    obsecureText: true,
                                    hintLabel: '******',
                                    controller: confirmPasswordController,
                                    textInputType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'emptyField'.tr;
                                      }
                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        return 'confirmNotPass'.tr;
                                      }
                                      return null;
                                    },
                                    function: () {
                                      confirmPasswordController.clear();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 60,
                              ),
                              Text(
                                '${'proxy_code'.tr} ',
                                style: const TextStyle(
                                  color: Color(0xff212A37),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 70,
                              ),
                              BuildLoginSignUpTextBox(
                                obsecureText: false,
                                hintLabel: 'proxy_code_hint_of_TF'.tr,
                                controller: codeController,
                                textInputType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'emptyField'.tr;
                                  }
                                  return null;
                                },
                                function: () {
                                  codeController.clear();
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 20,
                              ),
                              BlocConsumer<SignUpCubit, SignUpState>(
                                listener: (context, state) {
                                  if (state is SignUpStateLoading) {
                                    showOverlayNotification(
                                      (context) {
                                        return const OverlayLoading();
                                      },
                                      position: NotificationPosition.bottom,
                                      key: const ValueKey('message'),
                                    );
                                  }
                                  if (state is SignUpStateSuccess) {
                                    Navigator.pushReplacementNamed(
                                        context, PermissionScreen.routeName);
                                  }
                                  if (state is SignUpStateError) {
                                    Fluttertoast.showToast(
                                        msg: state.errorMessage);
                                  }
                                },
                                builder: (context, state) {
                                  return Center(
                                    child: DefaultButton(
                                      function: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<SignUpCubit>().signUp(
                                                code: codeController.text,
                                                name: nameController.text,
                                                // email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                mobile: countryCode +
                                                    mobileController.text,
                                              );
                                        }
                                      },
                                      text: 'register'.tr,
                                      titleColor: Colors.black,
                                      width: double.infinity,
                                      radius: 16,
                                      height: 60.0,
                                      background: kBackgroundColor,
                                      fontSize: 18,
                                      toUpper: false,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 70,
                              ),
                              Row(
                                children: [
                                  Text('haveAccount'.tr),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.routeName);
                                    },
                                    child: Text(
                                      'login'.tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
