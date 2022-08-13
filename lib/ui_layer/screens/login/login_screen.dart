import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/logic_layer/login/login_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/home/home_screen.dart';
import 'package:driver/ui_layer/screens/layout/layout_screen.dart';
import 'package:driver/ui_layer/screens/permission/permission_screen.dart';
import 'package:driver/ui_layer/screens/sign_up/sign_up_screen.dart';
import 'package:driver/ui_layer/widgets/shared/build_login_text_box.dart';
import 'package:driver/ui_layer/widgets/shared/custom_text_field/custom_TextField_without_icon.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String countryCode = '';
  String errorText = '';
  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginStateLoading) {
              showOverlayNotification(
                (context) {
                  return const OverlayLoading();
                },
                position: NotificationPosition.bottom,
                key: const ValueKey('message'),
              );
            }
            if (state is LoginStateSuccess) {
              Fluttertoast.showToast(
                msg: state.message,
              );
              Navigator.pushNamed(
                context,
                PermissionScreen.routeName,
              );
            }
            if (state is LoginStateError) {
              Fluttertoast.showToast(
                msg: state.error,
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  Hero(
                    tag: 'splash',
                    child: Center(
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
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/Rectangle_login.png'),
                            fit: BoxFit.fill),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 8,
                            ),
                            Center(
                              child: Text(
                                'enter'.tr + ' ' + 'yourNumber'.tr,
                                style: const TextStyle(
                                  color: Color(0xff212A37),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    CountryCodePicker(
                                      onChanged: (code) {
                                        countryCode = '${code.dialCode}';
                                      },
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: 'EG',
                                      favorite: ['+20', 'مصر'],
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,
                                      onInit: (code) {
                                        countryCode = '$code';
                                      },
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
                                          textInputAction: TextInputAction.next,
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'emptyField'.tr;
                                            }
                                            if (value.length < 10) {
                                              return 'lessThan10'.tr;
                                            }
                                            if (phoneController.text[0] ==
                                                '0') {
                                              return "can'tWith0".tr;
                                            }
                                          },
                                          controller: phoneController,
                                          hintLabel: '0123456789',
                                          textInputType: TextInputType.phone,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        phoneController.clear();
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
                              height: MediaQuery.of(context).size.height / 40,
                            ),
                            Text(
                              'enter'.tr + ' ' + 'passwordLabel'.tr,
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
                                  controller: passwordController,
                                  textInputType: TextInputType.visiblePassword,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'emptyField'.tr;
                                    }
                                    if (value.length < 6) {
                                      return 'passwordLess6'.tr;
                                    }
                                  },
                                  function: () {
                                    passwordController.clear();
                                  },
                                ),
                              ),
                            ),
                            const Spacer(),
                            Center(
                              child: DefaultButton(
                                function: () {
                                  final formState = _formKey.currentState;
                                  if (formState!.validate()) {
                                    String finalNumber =
                                        '$countryCode${phoneController.text}';

                                    context.read<LoginCubit>().login(
                                          phone: finalNumber.toString(),
                                          password: passwordController.text,
                                        );
                                  }
                                },
                                text: 'login'.tr,
                                titleColor: Colors.black,
                                width: double.infinity,
                                radius: 16,
                                height: 60.0,
                                background: kBackgroundColor,
                                fontSize: 18,
                                toUpper: false,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 70,
                            ),
                            Row(
                              children: [
                                Text('noAccount'.tr),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, SignUpScreen.routeName);
                                  },
                                  child: Text(
                                    'register'.tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
