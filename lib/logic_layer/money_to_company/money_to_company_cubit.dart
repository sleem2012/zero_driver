import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'money_to_company_state.dart';

class MoneyToCompanyCubit extends Cubit<MoneyToCompanyState> {
  MoneyToCompanyCubit() : super(MoneyToCompanyInitial());

  /// getMoneyToCompany
  pointsToMoney(
      {required String mobileRecive,
      required int money,
      required int paymentMehodId}) async {
    emit(MoneyToCompanyStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          data: {
            'money': money,
            'panymentmethod_id': paymentMehodId,
            'mobile': mobileRecive,
          },
          path: kTransferToCompany,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          emit(MoneyToCompanyStateSuccess(message: response.data['message']));
        } else {
          emit(MoneyToCompanyStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(MoneyToCompanyStateError(error: e.toString()));
      }
    } else {
      emit(const MoneyToCompanyStateError(error: 'No Internet'));
    }
  }
}
