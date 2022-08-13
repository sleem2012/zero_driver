import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({required String phone, required String password}) async {
    emit(LoginStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response =
            await DioHelper.postDataRegister(path: kLoginEndPoint, data: {
          "password": password,
          "mobile": phone,
          "role": "2",
          "device_token": await FirebaseMessaging.instance.getToken()
        });
        if (response.statusCode == 200) {
          saveUserToken(response.data['data']['token']);
          saveUserId(response.data['data']['id'].toString());
          saveUserName(response.data['data']['name'].toString());
          saveUserPhone(response.data['data']['mobile'].toString());
          saveUserImage(response.data['data']['image'].toString());
          emit(LoginStateSuccess(message: response.data['message']));
        } else {
          emit(LoginStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(LoginStateError(error: e.toString()));
      }
    } else {
      emit(const LoginStateError(error: 'No Internet'));
    }
  }
}
