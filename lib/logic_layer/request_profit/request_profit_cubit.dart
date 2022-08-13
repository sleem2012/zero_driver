import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain_layer/local/shared_preferences.dart';
import '../../domain_layer/remote/end_point.dart';
import '../../domain_layer/remote/remote.dart';

part 'request_profit_state.dart';

class RequestProfitCubit extends Cubit<RequestProfitState> {
  RequestProfitCubit() : super(RequestProfitInitial());

  requestProfit() async {
    emit(RequestProfitLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: kRequestProfit,
          token: getUserToken(),
        );

        if (response.statusCode == 200) {
          emit(RequestProfitLoaded(message: response.data['message']));
          log(response.data['message']);
        } else {
          log(response.data['message']);

          emit(RequestProfitLoadingError(response.data['message']));
        }
      } catch (e) {
        emit(RequestProfitLoadingError(e.toString()));
      }
    } else {
      emit(const RequestProfitLoadingError('No Internet'));
    }
  }
}
