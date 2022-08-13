import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> signUp({
    required String name,
    required String code,
    // required String email,
    required String password,
    required String mobile,
  }) async {
    emit(SignUpStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response =
            await DioHelper.postDataRegister(path: kSignUpEndPoint, data: {
          "name": name,
          // "email": email,
          "password": password,
          "mobile": mobile,
          "proxyCode": code,
          "role_id": "2",
          "device_token": await FirebaseMessaging.instance.getToken()
        });
        if (response.statusCode == 200) {
          print(response);
          print('2');
          saveUserToken(response.data['data']['token']);

          saveUserId(response.data['data']['id'].toString());

          saveUserName(response.data['data']['name'].toString());
          saveUserPhone(response.data['data']['mobile'].toString());
          emit(SignUpStateSuccess(message: response.data['message']));
        } else {
          print('3');
          emit(SignUpStateError(errorMessage: '${response.data['message']}'));
        }
      } catch (e) {
        emit(SignUpStateError(errorMessage: e.toString()));
      }
    } else {
      emit(const SignUpStateError(errorMessage: 'No Internet'));
    }
  }
}
