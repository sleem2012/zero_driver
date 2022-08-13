import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/user_info/user_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInfoInitial());

  getUserInfo() async {
    emit(UserInfoLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: kUserInfo,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          UserInfo userInfo = UserInfo.fromJson(response.data);
          saveUserName(userInfo.data!.name.toString());
          saveUserPhone(userInfo.data!.mobile.toString());
          saveUserImage(userInfo.data!.image.toString());
          saveCarColor(userInfo.data!.carColor.toString());
          saveCarModel(userInfo.data!.carModels.toString());
          saveCarNumber(userInfo.data!.carNumber.toString());
          saveUserRate(userInfo.data!.rating!.toDouble().toString());
          saveCarType(userInfo.data!.serviceId!.toInt());
          emit(UserInfoLoaded(userInfo: userInfo));
        } else {
          emit(UserInfoError(errorMessage: '${response.data['message']}'));
        }
      } catch (e) {
        emit(UserInfoError(errorMessage: e.toString()));
      }
    } else {
      emit(const UserInfoError(errorMessage: 'No Internet'));
    }
  }
}
