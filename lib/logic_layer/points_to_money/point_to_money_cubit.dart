import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'point_to_money_state.dart';

class PointToMoneyCubit extends Cubit<PointToMoneyState> {
  PointToMoneyCubit() : super(PointToMoneyInitial());

  /// getPointToMoney
  pointToMoney({required String money}) async {
    emit(PointToMoneyStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          data: {'points': money},
          path: kPointsToMoney,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          emit(PointToMoneyStateSuccess(message: response.data['message']));
        } else {
          emit(PointToMoneyStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(PointToMoneyStateError(error: e.toString()));
      }
    } else {
      emit(const PointToMoneyStateError(error: 'No Internet'));
    }
  }
}
