import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:driver/logic_layer/points/points_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'transfer_points_state.dart';

class TransferPointsCubit extends Cubit<TransferPointsState> {
  TransferPointsCubit() : super(TransferPointsInitial());

  /// getTransferPoints
  transferPoints({required String mobileRecive, required int points}) async {
    emit(TransferPointsStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          data: {'mobile_recive': mobileRecive, 'points': points},
          path: kTransferPoints,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          emit(TransferPointsStateSuccess(message: response.data['message']));
        } else {
          emit(TransferPointsStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(TransferPointsStateError(error: e.toString()));
      }
    } else {
      emit(const TransferPointsStateError(error: 'No Internet'));
    }
  }
}
