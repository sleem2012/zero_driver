import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';

import 'package:driver/domain_layer/models/my_trips/item.dart';
import 'package:driver/logic_layer/support/support_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:overlay_support/overlay_support.dart';

class TripHistoryCard extends StatelessWidget {
  final Item? tripInfo;
  const TripHistoryCard({
    Key? key,
    required this.tripInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return ComplaintBottomSheet(
              requestId: tripInfo!.id,
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+ ${tripInfo!.points} ' + 'points'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      tripInfo!.price.toString() + ' ' + 'currency'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'earning'.tr +
                          tripInfo!.finalPrice.toString() +
                          ' ' +
                          'currency'.tr,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: Text(
                        tripInfo!.startAddress.toString(),
                      ),
                    ),
                  ],
                ),
                sizedBoxH5,
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    Expanded(
                      child: Text(
                        tripInfo!.endAddress.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ComplaintBottomSheet extends StatefulWidget {
  final int? requestId;
  const ComplaintBottomSheet({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  _ComplaintBottomSheetState createState() => _ComplaintBottomSheetState();
}

class _ComplaintBottomSheetState extends State<ComplaintBottomSheet> {
  TextEditingController complainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportCubit(),
      child: Form(
        key: _formKey,
        child: BlocConsumer<SupportCubit, SupportState>(
          listener: (context, state) {
            if (state is SupportStateLoading) {
              showOverlayNotification(
                (context) {
                  return const OverlayLoading();
                },
                position: NotificationPosition.bottom,
                key: const ValueKey('message'),
              );
            }
            if (state is SupportStateSuccess) {
              Fluttertoast.showToast(msg: state.message);
              Navigator.pop(context);
            }
            if (state is SupportStateError) {
              Fluttertoast.showToast(msg: state.error);
            }
          },
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'complaint'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: complainController,
                    validator: (String? val) =>
                        val!.isEmpty ? 'emptyField'.tr : null,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                sizedBoxH10,
                DefaultButton(
                  background: kDefaultColor,
                  fontSize: 18,
                  height: SizeConfig.blockSizeVertical * 7,
                  toUpper: false,
                  radius: 10,
                  text: 'send_complaint'.tr,
                  function: () {
                    final formState = _formKey.currentState;
                    if (formState!.validate()) {
                      context.read<SupportCubit>().sendMessage(
                          message: complainController.text,
                          requestId: widget.requestId);
                    }
                  },
                  titleColor: Colors.white,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
