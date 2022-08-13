import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain_layer/remote/remote.dart';

part 'latest_addresses_state.dart';

class LatestAddressesCubit extends Cubit<LatestAddressesState> {
  LatestAddressesCubit() : super(LatestAddressesInitial());



  Future<void> getLatestAddresses() async {
    emit(LatestAddressStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response =
            await DioHelper.getData(path: kLatestAddress, token: getUserToken());
        if (response.statusCode == 200) {
          saveUserToken(response.data['data']['token']);
          saveUserId(response.data['data']['id'].toString());
          saveUserName(response.data['data']['name'].toString());
          saveUserPhone(response.data['data']['mobile'].toString());
          saveUserImage(response.data['data']['image'].toString());
          emit(LatestAddressStateSuccess(message: response.data['message']));
        } else {
          emit(LatestAddressStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(LatestAddressStateError(error: e.toString()));
      }
    } else {
      emit(const LatestAddressStateError(error: 'No Internet'));
    }










  }
}
