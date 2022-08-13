import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'current_trip_state.dart';

class CurrentTripCubit extends Cubit<CurrentTripState> {
  CurrentTripCubit() : super(CurrentTripInitial());
  TripInfo tripInfo = const TripInfo();
  getCurrentTrip() async {
    emit(GetCurrentTripStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('object');

      try {
        final response = await DioHelper.getData(
          path: kGetCurrentTrip,
          token: getUserToken(),
        );
        emit(GetCurrentTriStateSuc());
        print(tripInfo.currentStatus);
        if (response.statusCode == 200) {
          print(response.statusCode);
          tripInfo = TripInfo.fromJson(response.data['data']);
          print(tripInfo);
          print(tripInfo.currentStatus);
          emit(GetCurrentTriStateSuc());
          print(tripInfo.currentStatus);
          if (tripInfo.currentStatus == 1) {
            TripInfo tripInfo = TripInfo.fromJson(response.data['data']);
            print(tripInfo.tripStatus);
            emit(CurrentTripAccepted(tripInfo: tripInfo));
          } else if (tripInfo.currentStatus == 3) {
            TripInfo tripInfo = TripInfo.fromJson(response.data['data']);
            print(tripInfo.tripStatus);
            emit(CurrentTripStarted(tripInfo: tripInfo,haveTrip: response.data['data']['have_trip'], haveNewTrip: response.data['data']['have_new_trip']));
          } else if (tripInfo.currentStatus == 7) {
            TripInfo tripInfo = TripInfo.fromJson(response.data['data']);
            print(tripInfo.tripStatus);
            emit(CurrentTripDriverArrived(tripInfo: tripInfo));
          }
        } else {
          emit(GetCurrentTripStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(GetCurrentTripStateError(error: e.toString()));
      }
    } else {
      emit(const GetCurrentTripStateError(error: 'No Internet'));
    }
  }
}
