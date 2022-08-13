import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'help_state.dart';

class HelpCubit extends Cubit<HelpState> {
  HelpCubit() : super(HelpInitial());
  static HelpCubit get(context) => BlocProvider.of(context);
  getHelpData() {
    emit(GetHelpDataLoading());
    DioHelper.getData(
      path: kGetHelpEndPoints,
      token: getUserToken(),
    ).then((value) {
      emit(GetHelpDataSuc(
        name: value.data['data']['name'],
        description: value.data['data']['description'],
      ));
    }).catchError((e) {
      if (e is DioError) {
        emit(GetHelpDataError('${e.response!.data['message']}'));
      } else {}
    });
  }
}
