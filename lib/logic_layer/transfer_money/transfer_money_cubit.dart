import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'transfer_money_state.dart';

class TransferMoneyCubit extends Cubit<TransferMoneyState> {
  TransferMoneyCubit() : super(TransferMoneyInitial());

  /// getTransferMoney
  transferMoney({required String mobileRecive, required int points}) async {
    emit(TransferMoneyStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          data: {'mobile_recive': mobileRecive, 'points': points},
          path: kTransferMoney,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          emit(TransferMoneyStateSuccess(message: response.data['message']));
        } else {
          emit(TransferMoneyStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(TransferMoneyStateError(error: e.toString()));
      }
    } else {
      emit(const TransferMoneyStateError(error: 'No Internet'));
    }
  }
}
