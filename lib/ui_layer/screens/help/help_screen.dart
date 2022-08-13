import 'package:driver/logic_layer/help/help_cubit.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:nations/nations.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/help-screen';
  const HelpScreen({Key? key}) : super(key: key);
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
        title: Text(
          'help'.tr,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => HelpCubit()..getHelpData(),
        child: BlocBuilder<HelpCubit, HelpState>(
          builder: (context, state) {
            if (state is GetHelpDataLoading) {
              return LoadingWidget();
            }
            if (state is GetHelpDataSuc) {
              var document = parse('${state.description}');
              print(document.outerHtml);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text('${document.body!.text}'),
                  ],
                ),
              );
            }
            if (state is GetHelpDataError) {
              return LoadingWidget();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
