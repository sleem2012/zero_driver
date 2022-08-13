import 'package:driver/logic_layer/current_trip/current_trip_cubit.dart';
import 'package:driver/logic_layer/start_or_finish/start_or_finish_cubit.dart';
import 'package:driver/ui_layer/screens/layout/layout_screen.dart';
import 'package:driver/ui_layer/widgets/loading_widget.dart';
import 'package:driver/ui_layer/widgets/map_with_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../destination/destination_screen.dart';

class CurrentTripPlaceHolder extends StatefulWidget {
  static const routeName = '/current-trip';
  const CurrentTripPlaceHolder({Key? key}) : super(key: key);

  @override
  State<CurrentTripPlaceHolder> createState() => _CurrentTripPlaceHolderState();
}

class _CurrentTripPlaceHolderState extends State<CurrentTripPlaceHolder> {
  @override
  void initState() {
    toggleFunction();
    super.initState();
  }

  toggleFunction() async {
    context.read<CurrentTripCubit>().getCurrentTrip();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentTripCubit, CurrentTripState>(
      listener: (context, state) {
        debugPrint(state.toString());
        if (state is CurrentTripAccepted) {
          context.read<StartOrFinishCubit>()..emit(StartOrFinishInitial());

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MapWithRoutes(
                  tripInfo: state.tripInfo!,
                ),
              ),
              (Route<dynamic> route) => false);
        }
        if (state is CurrentTripStarted) {
          context.read<StartOrFinishCubit>()..emit(StartTripSuccess());
          if(state.haveTrip == true){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MapWithRoutes(
                    tripInfo: state.tripInfo!,
                    haveNewTrip: state.haveNewTrip,
                  ),
                ),
                    (Route<dynamic> route) => false);
          }
          // if(state.haveTrip == false){
          //   if(state.haveNewTrip == true){
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => MapWithRoutes(
          //             tripInfo: state.tripInfo!,
          //           ),
          //         ),
          //             (Route<dynamic> route) => false);
          //   }
          //   if(state.haveNewTrip == false){
          //     Navigator.pushReplacementNamed(
          //         context, LayoutScreen.routeName);
          //   }
          // }
        }
        if (state is CurrentTripDriverArrived) {
          context.read<StartOrFinishCubit>()..emit(DriverArrivedSuccess());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MapWithRoutes(
                  tripInfo: state.tripInfo!,
                ),
              ),
              (Route<dynamic> route) => false);
        }
        if (state is GetCurrentTripStateError) {
          print(state.error);
          Navigator.pushReplacementNamed(context, DestinationScreen.routeName);
        }
      },
      builder: (context, state) {
        debugPrint(state.toString());
        return const Scaffold(
          body: LoadingWidget(),
        );
      },
    );
  }
}
