import 'package:driver/logic_layer/support/support_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';

class SupportScreen extends StatefulWidget {
  static const routeName = '/support-screen';
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('support'.tr),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => SupportCubit(),
          child: BlocConsumer<SupportCubit, SupportState>(
            listener: (context, state) {
              if (state is SupportStateLoading) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SupportStateSuccess) {
                Fluttertoast.showToast(
                  msg: state.message,
                );
                Navigator.pop(context);
              }
              if (state is SupportStateError) {
                Fluttertoast.showToast(
                  msg: state.error,
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'message'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kDefaultColor,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                    child: TextFormField(
                      controller: noteController,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          labelText: '', border: InputBorder.none),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (noteController.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'emptyField'.tr);
                      }
                      if (noteController.text.isNotEmpty) {
                        context.read<SupportCubit>().sendMessage(
                            message: noteController.text.toString());
                      }
                    },
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            'send'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
