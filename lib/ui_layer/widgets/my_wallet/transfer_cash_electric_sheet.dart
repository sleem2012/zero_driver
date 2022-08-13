import 'package:driver/logic_layer/get_payment_method/get_payment_method_cubit.dart';
import 'package:driver/logic_layer/money_to_company/money_to_company_cubit.dart';
import 'package:driver/logic_layer/points/points_cubit.dart';
import 'package:driver/logic_layer/points_to_money/point_to_money_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/error_display.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:overlay_support/overlay_support.dart';

class TransferCashToElectronicWalletModelSheet extends StatefulWidget {
  const TransferCashToElectronicWalletModelSheet({
    Key? key,
    required this.labelText1,
    required this.controller1,
    required this.validator1,
    required this.labelText2,
    required this.controller2,
    required this.validator2,
    required this.function,
    required this.walletType,
  }) : super(key: key);

  /// controller1
  final TextEditingController controller1;

  /// validator1
  final String? Function(String?) validator1;

  /// label text1
  final String labelText1;

  /// controller1
  final TextEditingController controller2;

  /// validator1
  final String? Function(String?) validator2;

  /// label text1
  final String labelText2;

  final List<String> walletType;

  //function of button
  final VoidCallback? function;

  @override
  State<TransferCashToElectronicWalletModelSheet> createState() =>
      _TransferCashToElectronicWalletModelSheetState();
}

class _TransferCashToElectronicWalletModelSheetState
    extends State<TransferCashToElectronicWalletModelSheet> {
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String newVal = '';
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetPaymentMethodCubit()..getPaymentMethodPaymentMethod(),
        ),
        BlocProvider(
          create: (context) => MoneyToCompanyCubit(),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: SizeConfig.blockSizeVertical * 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.clear)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'cash'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget.controller1,
                  keyboardType: TextInputType.number,
                  validator: widget.validator1,
                  decoration: InputDecoration(
                    labelText: widget.labelText1.toString(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'wallet_number'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget.controller2,
                  keyboardType: TextInputType.phone,
                  validator: widget.validator2,
                  decoration: InputDecoration(
                    labelText: widget.labelText2.toString(),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'wallet_type'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                //drop down
                BlocBuilder<GetPaymentMethodCubit, GetPaymentMethodState>(
                  builder: (context, state) {
                    if (state is GetPaymentMethodStateLoading) {
                      return SizedBox(
                        height: SizeConfig.blockSizeVertical * 10,
                        child: const LoadingWidget(),
                      );
                    }
                    if (state is GetPaymentMethodStateSuccess) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              focusColor: kDefaultColor,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: kDefaultColor,
                              ),
                              hint: const Text("Choose Unit"),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: kDefaultColor,
                                  fontWeight: FontWeight.bold),
                              value: context
                                  .read<GetPaymentMethodCubit>()
                                  .selectedPayment,
                              onChanged: (newValue) {
                                context
                                    .read<GetPaymentMethodCubit>()
                                    .changeDropDownValue(newValue);
                              },
                              items: context
                                  .read<GetPaymentMethodCubit>()
                                  .paymentMethodList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Text(
                                      value,
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    }
                    if (state is GetPaymentMethodStateError) {
                      return ErrorDisplay(
                          errorMessage: state.error,
                          width: SizeConfig.blockSizeHorizontal * 5);
                    }
                    return Container();
                  },
                ),
                // Spacer(),
                sizedBoxH10,
                BlocConsumer<MoneyToCompanyCubit, MoneyToCompanyState>(
                  listener: (context, state) {
                    if (state is MoneyToCompanyStateLoading) {
                      showOverlayNotification(
                        (context) {
                          return const OverlayLoading();
                        },
                        position: NotificationPosition.bottom,
                        key: const ValueKey('message'),
                      );
                    }
                    if (state is MoneyToCompanyStateSuccess) {
                      Fluttertoast.showToast(msg: state.message);
                      context.read<PointsCubit>().getMyPoints();

                      widget.controller1.clear();
                      widget.controller2.clear();
                      Navigator.pop(context);
                    }
                    if (state is MoneyToCompanyStateError) {
                      Fluttertoast.showToast(msg: state.error);
                    }
                  },
                  builder: (context, state) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: DefaultButton(
                          function: () {
                            final formState = _formKey.currentState;
                            if (formState!.validate()) {
                              context.read<MoneyToCompanyCubit>().pointsToMoney(
                                    mobileRecive: widget.controller2.text,
                                    money: int.parse(widget.controller1.text),
                                    paymentMehodId: int.parse(context
                                        .read<GetPaymentMethodCubit>()
                                        .selectedPaymentId),
                                  );
                            }
                          },
                          text: 'transfer_cash_to_electronic_wallet'.tr,
                          titleColor: Colors.white,
                          width: MediaQuery.of(context).size.width / 1.3,
                          radius: 16,
                          height: 60.0,
                          background: kDefaultColor,
                          fontSize: 14,
                          toUpper: false,
                        ),
                      ),
                    );
                  },
                ),
                sizedBoxH20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
