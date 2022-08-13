import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain_layer/local/shared_preferences.dart';
import '../../domain_layer/remote/remote.dart';

part 'destination_state.dart';

class DestinationCubit extends Cubit<DestinationState> {
  DestinationCubit() : super(DestinationInitial());

  sendDestination(double lat, double long) async {
    emit(DestinationLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          path: kDestinationEndpoint,
          token: getUserToken(),
          data: {
            "target_long": long,
            "target_lat": lat,
          },
        );

        if (response.statusCode == 200) {
          emit(DestinationLoaded());
        }
      } catch (e) {}
    }
  }

  skipDestionation() async {
    //
    emit(DestinationLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: kSkipDest,
          token: getUserToken(),
        );

        if (response.statusCode == 200) {
          emit(DestinationLoaded());
        }
      } catch (e) {}
    }
  }
}
