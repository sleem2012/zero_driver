import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/my_trips/my_trips.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';

part 'my_trips_state.dart';

class MyTripsCubit extends Cubit<MyTripsState> {
  MyTripsCubit() : super(MyTripsInitial());

  /// Get MyTrips
  getMyTrips() {
    emit(MyTripsStateLoading());
    DioHelper.getData(
      path: kMyTrips,
      token: getUserToken(),
    ).then((value) {
      MyTrips myTrips = MyTrips.fromJson(value.data);
      emit(MyTripsStateSuccess(myTrips: myTrips));
    }).catchError((e) {
      if (e is DioError) {
        print('${e.response!.data['message']}');
        emit(MyTripsStateError(error: '${e.response!.data['message']}'));
      } else {
        print('${e}');
      }
    });
  }
}
