import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nations/nations.dart';
import 'package:driver/domain_layer/models/points/points.dart';
import 'package:driver/logic_layer/points/points_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/shared/default_button.dart';
import 'package:driver/ui_layer/widgets/shared/error_display.dart';
import 'package:driver/ui_layer/widgets/shared/overlay_loading.dart';

class PointsScreen extends StatefulWidget {
  static const routeName = '/wallet-screen';
  const PointsScreen({Key? key}) : super(key: key);

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  void initState() {
    context.read<PointsCubit>().getMyPoints();
    super.initState();
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
      ),
      body: BlocConsumer<PointsCubit, PointsState>(
        listener: (context, state) {
          if (state is PointsStateError) {
            Fluttertoast.showToast(
              msg: state.error,
            );
          }
        },
        builder: (context, state) {
          if (state is PointsStateLoading) {
            return const LoadingWidget();
          }
          if (state is PointsStateSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyPointsWidget(
                    points: state.points,
                  ),
                ),
              ],
            );
          }
          if (state is PointsStateError) {
            return Center(
              child: ErrorDisplay(
                errorMessage: state.error,
                width: 50,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class MyPointsWidget extends StatelessWidget {
  final Points points;
  const MyPointsWidget({
    Key? key,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height / 5.8,
        decoration: BoxDecoration(
          color: Colors.green[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${"my_trips".tr} : ${points.data!.totalTrip} ${'trips'.tr}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${'my_points'.tr} : ${points.data!.totalPoint} ${'points'.tr}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${'my_cash'.tr} : ${points.data!.totalCash} ${'currency'.tr}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
