import 'package:driver/domain_layer/models/points/points.dart';
import 'package:driver/logic_layer/points/points_cubit.dart';
import 'package:driver/logic_layer/points_to_money/point_to_money_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/screens/points/points_screen.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/my_wallet/exchange_points_sheet.dart';
import 'package:driver/ui_layer/widgets/my_wallet/transfer_cash_electric_sheet.dart';
import 'package:driver/ui_layer/widgets/my_wallet/transfer_cash_sheet.dart';
import 'package:driver/ui_layer/widgets/my_wallet/transfer_points_sheet.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/error_display.dart';
import 'package:flutter/material.dart';
import 'package:nations/nations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWalletScreen extends StatefulWidget {
  static const routeName = '/my-wallet';
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  TextEditingController transferUserNumber = TextEditingController();

  TextEditingController transferUserPoints = TextEditingController();

  TextEditingController exChangePoints = TextEditingController();

  TextEditingController transferCashToElectronicWallet =
      TextEditingController();

  TextEditingController electronicWalletMobileNumber = TextEditingController();

  TextEditingController transferUserNumberCash = TextEditingController();

  TextEditingController transferUserPointsCash = TextEditingController();

  @override
  void initState() {
    context.read<PointsCubit>().getMyPoints();

    super.initState();
  }

  @override
  void dispose() {
    transferUserNumber.dispose();
    transferUserPoints.dispose();
    exChangePoints.dispose();
    transferCashToElectronicWallet.dispose();
    electronicWalletMobileNumber.dispose();
    transferUserNumberCash.dispose();
    transferUserPointsCash.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        elevation: 2.0,
        title: Text(
          'my_wallet'.tr,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      // drawer: BuildDrawer(),
      body: Container(
        color: const Color(
          0xFFE5E5E5,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<PointsCubit>().getMyPoints();
          },
          child: ListView(
            children: [
              sizedBoxH10,
              BlocBuilder<PointsCubit, PointsState>(builder: (context, state) {
                if (state is PointsStateLoading) {
                  return const LoadingWidget();
                }
                if (state is PointsStateSuccess) {
                  return MyPointsWidget(
                    points: state.points,
                  );
                }
                if (state is PointsStateError) {
                  return ErrorDisplay(errorMessage: state.error, width: 20);
                }
                return Container();
              }),
              sizedBoxH10,
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return TransferPointsModelSheet(
                          labelText1: 'user_mobile_number'.tr,
                          controller1: transferUserNumber,
                          validator1: (value) {
                            if (value!.isEmpty) {
                              return 'emptyField'.tr;
                            }
                          },
                          labelText2: 'points'.tr,
                          controller2: transferUserPoints,
                          validator2: (value) {
                            if (value!.isEmpty) {
                              return 'emptyField'.tr;
                            }
                          },
                          function: () {},
                        );
                      });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/icons/transfer.png'),
                            fit: BoxFit.cover,
                          )),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'transfer_points'.tr,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              sizedBoxH10,
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return BlocProvider(
                          create: (context) => PointToMoneyCubit(),
                          child: ExchangePointsModelSheet(
                            labelText: 'points'.tr,
                            controller: exChangePoints,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'emptyField'.tr;
                              }
                            },
                            function: () {},
                          ),
                        );
                      });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image:
                                AssetImage('assets/icons/exchange_points.png'),
                            fit: BoxFit.cover,
                          )),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'ex_change_points'.tr,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              sizedBoxH10,
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: SizeConfig.blockSizeVertical * 80,
                          child: TransferCashToElectronicWalletModelSheet(
                            labelText1: 'cash'.tr,
                            controller1: transferCashToElectronicWallet,
                            walletType: const [
                              'vadofone',
                              'Orange',
                              'Etisalat',
                              'We'
                            ],
                            validator1: (value) {
                              if (value!.isEmpty) {
                                return 'emptyField'.tr;
                              }
                            },
                            controller2: electronicWalletMobileNumber,
                            labelText2: 'wallet_number'.tr,
                            validator2: (value) {
                              if (value!.isEmpty) {
                                return 'emptyField'.tr;
                              }
                            },
                            function: () {},
                          ),
                        );
                      });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/icons/wallet.png'),
                            fit: BoxFit.cover,
                          )),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'transfer_cash_to_electronic_wallet'.tr,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              sizedBoxH10,
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return TransferCashModelSheet(
                          labelText1: 'user_mobile_number'.tr,
                          controller1: transferUserNumberCash,
                          validator1: (value) {
                            if (value!.isEmpty) {
                              return 'emptyField'.tr;
                            }
                          },
                          controller2: transferUserPointsCash,
                          labelText2: 'cash'.tr,
                          validator2: (value) {
                            if (value!.isEmpty) {
                              return 'emptyField'.tr;
                            }
                          },
                          function: () {},
                        );
                      });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image:
                                AssetImage('assets/icons/transfer_money.png'),
                            fit: BoxFit.cover,
                          )),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'transfer_cash'.tr,
                          style: TextStyle(color: Colors.black, fontSize: 20),
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
