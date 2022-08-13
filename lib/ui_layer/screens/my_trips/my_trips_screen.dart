import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/my_trips/trip_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:driver/domain_layer/models/my_trips/item.dart';
import 'package:driver/logic_layer/my_trips/my_trips_cubit.dart';
import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:driver/ui_layer/helpers/reusable/reusables.dart';
import 'package:driver/ui_layer/helpers/size_config/size_config.dart';
import 'package:driver/ui_layer/widgets/shared/cached_image_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nations/nations.dart';

class MyTripsScreen extends StatefulWidget {
  static const routeName = '/trips';
  const MyTripsScreen({Key? key}) : super(key: key);

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  @override
  void initState() {
    context.read<MyTripsCubit>().getMyTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MyTripsCubit>().getMyTrips();
        },
        child: ListView(
          children: [
            BlocConsumer<MyTripsCubit, MyTripsState>(
              listener: (context, state) {
                if (state is MyTripsStateError) {
                  Fluttertoast.showToast(
                    msg: state.error,
                  );
                }
              },
              builder: (context, state) {
                if (state is MyTripsStateLoading) {
                  return const LoadingWidget();
                }
                if (state is MyTripsStateSuccess) {
                  if (state.myTrips.data!.items!.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(height: SizeConfig.blockSizeVertical * 40),
                        Center(
                          child: Text('noTrips'.tr),
                        ),
                      ],
                    );
                  } else if (state.myTrips.data!.items!.isNotEmpty) {
                    return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: state.myTrips.data!.items!.length,
                      itemBuilder: (context, index) {
                        return TripHistoryCard(
                            tripInfo: state.myTrips.data!.items![index]);
                      },
                    );
                  }
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<bool> isSelected = [true, false];
