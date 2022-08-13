import 'package:driver/logic_layer/points/points_cubit.dart';
import 'package:driver/logic_layer/points_to_money/point_to_money_cubit.dart';
import 'package:driver/logic_layer/receiver_details/get_receiver_details_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';
import 'package:overlay_support/overlay_support.dart';

class ExchangePointsModelSheet extends StatefulWidget {
  const ExchangePointsModelSheet({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.validator,
    required this.function,
  }) : super(key: key);

  /// controller1
  final TextEditingController controller;

  /// validator1
  final String? Function(String?) validator;

  /// label text1
  final String labelText;

  //function of button
  final VoidCallback? function;

  @override
  State<ExchangePointsModelSheet> createState() =>
      _ExchangePointsModelSheetState();
}

class _ExchangePointsModelSheetState extends State<ExchangePointsModelSheet> {
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointToMoneyCubit, PointToMoneyState>(
      listener: (context, state) {
        if (state is PointToMoneyStateLoading) {
          showOverlayNotification(
            (context) {
              return const OverlayLoading();
            },
            position: NotificationPosition.bottom,
            key: const ValueKey('message'),
          );
        }
        if (state is PointToMoneyStateSuccess) {
          Fluttertoast.showToast(msg: state.message);
          widget.controller.clear();
          context.read<PointsCubit>().getMyPoints();

          Navigator.pop(context);
        }
        if (state is PointToMoneyStateError) {
          Fluttertoast.showToast(msg: state.error);
        }
      },
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          decoration: BoxDecoration(
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
                  'points'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    labelText: widget.labelText.toString(),
                    border: OutlineInputBorder(),
                  ),
                ),
                const Spacer(),
                Center(
                  child: DefaultButton(
                    function: () {
                      context.read<PointToMoneyCubit>().pointToMoney(
                            money: (widget.controller.text),
                          );
                    },
                    text: 'ex_change_points'.tr,
                    titleColor: Colors.white,
                    width: MediaQuery.of(context).size.width / 2.4,
                    radius: 16,
                    height: 60.0,
                    background: kDefaultColor,
                    fontSize: 14,
                    toUpper: false,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
