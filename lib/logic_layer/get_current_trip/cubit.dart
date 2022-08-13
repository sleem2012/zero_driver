import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:driver/logic_layer/get_current_trip/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCurrentTripCubit extends Cubit<GetCurrentTripStates> {
  GetCurrentTripCubit() : super(CurrentTripStateInitial());

  getCurrentTripData() {
    emit(GetCurrentTripStateLoading());
    DioHelper.getData(
      path: kGetCurrentTrip,
      token: getUserToken(),
    ).then((value) {
      print(value);
      if (value.data['data']['current_status'] == 1) {
        TripInfo tripInfo = TripInfo.fromJson(value.data['data']);
        emit(CurrentTripAccepted(tripInfo));
      }

      if (value.data['data']['current_status'] == 3) {
        TripInfo tripInfo = TripInfo.fromJson(value.data['data']);
        emit(CurrentTripStarted(tripInfo,value.data['data']['have_trip']));
      }
    }).catchError((e) {
      if (e is DioError) {
        emit(GetCurrentTripStateError('${e.response!.data['message']}'));
      } else {}
    });
  }
}
