import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/check_profile/check_profile.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'check_profile_state.dart';

class CheckProfileCubit extends Cubit<CheckProfileState> {
  CheckProfileCubit() : super(CheckProfileInitial());
  CheckProfile checkProfileModel = CheckProfile();

  /// get CheckProfile
  Future checkProfile() async {
    emit(CheckProfileStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: kCheckProfile,
          token: getUserToken(),
        );
        print(response.data);
        if (response.statusCode == 200) {
          print(response.data);

          CheckProfile checkProfile = CheckProfile.fromJson(response.data);
          checkProfileModel = CheckProfile.fromJson(response.data);
          emit(CheckProfileStateSuccess(checkProfile: checkProfile));
        } else {
          emit(CheckProfileStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(CheckProfileStateError(error: e.toString()));
      }
    } else {
      emit(const CheckProfileStateError(error: 'No Internet'));
    }
  }
}
