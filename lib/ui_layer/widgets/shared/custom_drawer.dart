import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/logic_layer/change_availability/change_availabilty_cubit.dart';
import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/logic_layer/user_info/user_info_cubit.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/help/help_screen.dart';
import 'package:driver/ui_layer/screens/login/login_screen.dart';
import 'package:driver/ui_layer/screens/my_trips/my_trips_screen.dart';
import 'package:driver/ui_layer/screens/my_wallet/my_wallet_screen.dart';
import 'package:driver/ui_layer/screens/support/support_screen.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/shared/drawer_header.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../logic_layer/request_profit/request_profit_cubit.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    context.read<CheckProfileCubit>().checkProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestProfitCubit(),
      child: Drawer(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<CheckProfileCubit>().checkProfile();
            context.read<UserInfoCubit>().getUserInfo();
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const CustomDrawerHeader(),
              // ListTile(
              //   leading: const Icon(
              //     FontAwesomeIcons.userCheck,
              //   ),
              //   title: Text(
              //     "completeRegistration".tr,
              //     style: const TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pushNamed(context, CompleteRegisteration.routeName);
              //   },
              // ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.moneyBillWaveAlt,
                ),
                title: Text(
                  "my_wallet".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, MyWalletScreen.routeName);
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.moneyBill,
                ),
                title: Text(
                  'tripHistory'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, MyTripsScreen.routeName);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help,
                ),
                title: Text(
                  "help".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, HelpScreen.routeName);
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.globe,
                ),
                title: Text(
                  "change_language".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Nations.updateLocale(Locale(
                    Nations.locale.languageCode == 'ar' ? 'en' : 'ar',
                  ));

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    // LayoutScreen.routeName,
                    (route) => false,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_center,
                ),
                title: Text(
                  "support".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, SupportScreen.routeName);
                },
              ),
              BlocBuilder<CheckProfileCubit, CheckProfileState>(
                builder: (context, state) {
                  if (state is CheckProfileStateLoading) {
                    return SizedBox(
                      height: SizeConfig.blockSizeVertical * 5,
                      child: const LoadingWidget(),
                    );
                  }
                  if (state is CheckProfileStateSuccess) {
                    if (!state.checkProfile.data!.profit) {
                      return BlocConsumer<RequestProfitCubit,
                          RequestProfitState>(
                        listener: (context, state) {
                          if (state is RequestProfitLoading) {
                            showOverlayNotification(
                              (context) {
                                return const OverlayLoading();
                              },
                              position: NotificationPosition.bottom,
                              key: const ValueKey('message'),
                            );
                          }
                          if (state is RequestProfitLoaded) {
                            Fluttertoast.showToast(msg: state.message);
                            context.read<CheckProfileCubit>().checkProfile();
                          }
                          if (state is RequestProfitLoadingError) {
                            Fluttertoast.showToast(msg: state.message);

                            context.read<CheckProfileCubit>().checkProfile();
                          }
                        },
                        builder: (context, state) {
                          return ListTile(
                            leading: const Icon(
                              Icons.monetization_on,
                            ),
                            title: Text(
                              "enable_profit".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<RequestProfitCubit>()
                                  .requestProfit();
                            },
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }
                  return Container();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: Text(
                  "logout".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  context
                      .read<ChangeAvailabilityCubit>()
                      .changeAvailability(false);

                  removeUserToken();
                  Navigator.pushNamedAndRemoveUntil(context,
                      LoginScreen.routeName, (Route<dynamic> route) => false);
                },
              ),
              sizedBoxH10,
              Center(child: Text('${'version'.tr} 1.1.0'))
            ],
          ),
        ),
      ),
    );
  }
}
