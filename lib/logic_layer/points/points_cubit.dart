import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/points/points.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  PointsCubit() : super(PointsInitial());

  /// get points
  getMyPoints() async {
    emit(PointsStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: kMyPoints,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          Points points = Points.fromJson(response.data);
          emit(PointsStateSuccess(points: points));
        } else {
          emit(PointsStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(PointsStateError(error: e.toString()));
      }
    } else {
      emit(const PointsStateError(error: 'No Internet'));
    }
  }
}
