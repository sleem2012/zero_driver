import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/billing_info/billing_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'billing_info_state.dart';

class BillingInfoCubit extends Cubit<BillingInfoState> {
  BillingInfoCubit() : super(BillingInfoInitial());

  /// Get BillingInfo
  getBillingInfo(int? requestId) async {
    emit(BillingInfoStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await Future.delayed(const Duration(seconds: 3))
            .then((value) => DioHelper.postData(
                  path: kBillingInfo,
                  token: getUserToken(),
                  data: {
                    'request_id': requestId,
                  },
                ));
        if (response.statusCode == 200) {
          BillingInfo billingInfo = BillingInfo.fromJson(response.data);
          emit(BillingInfoStateSuccess(billingInfo: billingInfo));
        } else {
          emit(BillingInfoStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(BillingInfoStateError(error: e.toString()));
      }
    } else {
      emit(const BillingInfoStateError(error: 'No Internet'));
    }
  }
}
