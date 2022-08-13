import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/payment_method/payment_method.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'get_payment_method_state.dart';

class GetPaymentMethodCubit extends Cubit<GetPaymentMethodState> {
  GetPaymentMethodCubit() : super(GetPaymentMethodInitial());
  String selectedPayment = '';
  String selectedPaymentId = '1';
  List<String> paymentMethodList = [];
  Map paymentMethodMap = {};

  getPaymentMethodPaymentMethod() async {
    emit(GetPaymentMethodStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: kPaymentMethod,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          paymentMethodMap = response.data['data'];
          paymentMethodMap.forEach((key, value) {
            paymentMethodList.add(value.toString());
          });
          selectedPayment = response.data['data']['1'];
          selectedPaymentId = paymentMethodMap.keys.toList().first;
          PaymentMethod paymentMethod = PaymentMethod.fromJson(response.data);
          emit(const GetPaymentMethodStateSuccess());
        } else {
          emit(
              GetPaymentMethodStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(GetPaymentMethodStateError(error: e.toString()));
      }
    } else {
      emit(const GetPaymentMethodStateError(error: 'No Internet'));
    }
  }

  changeDropDownValue(String? newValue) {
    selectedPayment = newValue.toString();

    selectedPaymentId = paymentMethodMap.keys
        .firstWhere((element) => paymentMethodMap[element] == selectedPayment);
    emit(GetPaymentMethodStateLoading());
    emit(const GetPaymentMethodStateSuccess());
  }
}
