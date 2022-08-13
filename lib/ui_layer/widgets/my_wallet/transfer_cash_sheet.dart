import 'package:driver/logic_layer/points/points_cubit.dart';
import 'package:driver/logic_layer/receiver_details/get_receiver_details_cubit.dart';
import 'package:driver/logic_layer/transfer_money/transfer_money_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:overlay_support/overlay_support.dart';

class TransferCashModelSheet extends StatefulWidget {
  const TransferCashModelSheet({
    Key? key,
    required this.labelText1,
    required this.controller1,
    required this.validator1,
    required this.labelText2,
    required this.controller2,
    required this.validator2,
    required this.function,
  }) : super(key: key);

  /// controller1
  final TextEditingController controller1;

  /// validator1
  final String? Function(String?) validator1;

  /// label text1
  final String labelText1;

  /// controller2
  final TextEditingController controller2;

  /// validator2
  final String? Function(String?) validator2;

  /// label text2
  final String labelText2;

  //function of button
  final VoidCallback? function;

  @override
  State<TransferCashModelSheet> createState() => _TransferCashModelSheetState();
}

class _TransferCashModelSheetState extends State<TransferCashModelSheet> {
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TransferMoneyCubit()..emit(TransferMoneyInitial()),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: SizeConfig.blockSizeVertical * 60,
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
                        child: const Icon(Icons.clear)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'user_mobile_number'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget.controller1,
                  keyboardType: TextInputType.phone,
                  validator: widget.validator1,
                  decoration: InputDecoration(
                    labelText: widget.labelText1.toString(),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (String? val) {
                    context
                        .read<GetReceiverDetailsCubit>()
                        .getReceiver(mobile: val.toString());
                  },
                ),
                BlocBuilder<GetReceiverDetailsCubit, GetReceiverDetailsState>(
                  builder: (context, state) {
                    if (state is GetReceiverStateLoading) {
                      return const LoadingWidget();
                    }
                    if (state is GetReceiverStateSuccess) {
                      return Column(
                        children: [sizedBoxH10, Text(state.message)],
                      );
                    }
                    if (state is GetReceiverStateError) {
                      return Text(state.errorMessage);
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'cash'.tr,
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
                const Spacer(),
                BlocConsumer<TransferMoneyCubit, TransferMoneyState>(
                  listener: (context, state) {
                    if (state is TransferMoneyStateLoading) {
                      showOverlayNotification(
                        (context) {
                          return const OverlayLoading();
                        },
                        position: NotificationPosition.bottom,
                        key: const ValueKey('message'),
                      );
                    }
                    if (state is TransferMoneyStateSuccess) {
                      context.read<PointsCubit>().getMyPoints();

                      Fluttertoast.showToast(msg: state.message);
                      Navigator.pop(context);
                    }
                    if (state is TransferMoneyStateError) {
                      Fluttertoast.showToast(msg: state.error);
                    }
                  },
                  builder: (context, state) {
                    return Center(
                      child: DefaultButton(
                        function: () {
                          final currentState = _formKey.currentState;
                          if (currentState!.validate()) {
                            context.read<TransferMoneyCubit>().transferMoney(
                                  mobileRecive: widget.controller1.text,
                                  points: int.parse(
                                    widget.controller2.text,
                                  ),
                                );
                          }
                        },
                        text: 'transfer_cash'.tr,
                        titleColor: Colors.white,
                        width: MediaQuery.of(context).size.width / 2.8,
                        radius: 16,
                        height: 60.0,
                        background: kDefaultColor,
                        fontSize: 14,
                        toUpper: false,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
