import 'package:driver/ui_layer/screens/complete_registration/complete_data.dart';
import 'package:driver/ui_layer/screens/complete_registration/update_driver_license.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/shared/error_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nations/nations.dart';
import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/screens/update_profile/update_profile_screen.dart';
import 'package:driver/ui_layer/screens/complete_registration/update_car_info.dart';

class CompleteRegisteration extends StatefulWidget {
  static const routeName = '/complete-register';
  const CompleteRegisteration({Key? key}) : super(key: key);

  @override
  State<CompleteRegisteration> createState() => _CompleteRegisterationState();
}

class _CompleteRegisterationState extends State<CompleteRegisteration> {
  @override
  void initState() {
    context.read<CheckProfileCubit>().checkProfile();
    super.initState();
  }

  // Future<bool> _willPopCallback() async {
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const LayoutScreen(),
  //       ),
  //       (Route<dynamic> route) => false);
  //   return true; // return true if the route to be popped
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const LayoutScreen(),
        //         ),
        //         (Route<dynamic> route) => false);
        //   },
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        // ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'completeRegistration'.tr,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<CheckProfileCubit, CheckProfileState>(
        builder: (context, state) {
          if (state is CheckProfileStateLoading) {
            return const LoadingWidget();
          }
          if (state is CheckProfileStateSuccess) {
            return Container(
              color: const Color(
                0xffE5E5E5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: Card(
                  elevation: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomListTile(
                        title: 'updateProfileInfo'.tr,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, UpdateProfile.routeName);
                        },
                        isFinished: true,
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      CustomListTile(
                        title: 'updateCarInfo'.tr,
                        onTap: () {
                          Navigator.pushNamed(context, UpdateCarInfo.routeName);
                          // if (!state.checkProfile.data!.frontSideCarLicense) {
                          // } else {
                          //   Fluttertoast.showToast(msg: 'alreadyUpdated'.tr);
                          // }
                        },
                        isFinished:
                            state.checkProfile.data!.frontSideCarLicense,
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      CustomListTile(
                        title: 'updateDriverLicense'.tr,
                        onTap: () {
                          Navigator.pushNamed(
                              context, UpdateDriverLicense.routeName);
                          // if (!state.checkProfile.data!.frontSideLicense) {
                          // } else {
                          //   Fluttertoast.showToast(msg: 'alreadyUpdated'.tr);
                          // }
                        },
                        isFinished: state.checkProfile.data!.frontSideLicense,
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      CustomListTile(
                        title: 'completeData'.tr,
                        onTap: () {
                          Navigator.pushNamed(context, CompleteData.routeName);
                          // if (!state.checkProfile.data!.frontSideCarLicense) {
                          // } else {
                          //   Fluttertoast.showToast(msg: 'alreadyUpdated'.tr);
                          // }
                        },
                        isFinished: state.checkProfile.data!.carNumberPicture,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state is CheckProfileStateError) {}
          return ErrorDisplay(
            width: 50,
            errorMessage: state.props.toString(),
          );
        },
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool isFinished;
  const CustomListTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          onTap();
        },
        icon: isFinished
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : const Icon(
                Icons.arrow_forward_ios,
                color: kDefaultColor,
              ),
      ),
    );
  }
}
