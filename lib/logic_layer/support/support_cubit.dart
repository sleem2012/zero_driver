import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';

part 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit() : super(SupportInitial());
  void sendMessage({required String message, int? requestId}) {
    emit(SupportStateLoading());
    DioHelper.postData(
        path: sendMessageToSupportEndPoints,
        token: getUserToken(),
        data: {'message': message, 'trip_id': requestId ?? ''}).then((value) {
      emit(SupportStateSuccess(value.data['message']));
    }).catchError((e) {
      if (e is DioError) {
        print('${e.response!.data['message']}');
        emit(SupportStateError('${e.response!.data['message']}'));
      } else {
        print(e.toString());
      }
    });
  }
}
