import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';

part 'get_receiver_details_state.dart';

class GetReceiverDetailsCubit extends Cubit<GetReceiverDetailsState> {
  GetReceiverDetailsCubit() : super(GetReceiverDetailsInitial());

  void getReceiver({required String mobile}) {
    emit(GetReceiverStateLoading());

    DioHelper.getData(
        path: kReceiverDetails,
        token: getUserToken(),
        query: {"mobile": mobile}).then((value) {
      emit(GetReceiverStateLoading());

      print(value);

      emit(GetReceiverStateSuccess(message: value.data['data']));
    }).catchError((e) {
      if (e is DioError) {
        emit(GetReceiverStateError(
            errorMessage: '${e.response!.data['message']}'));
      } else {}
    });
  }
}
