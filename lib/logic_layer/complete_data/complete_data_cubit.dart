import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'complete_data_state.dart';

class CompleteDataCubit extends Cubit<CompleteDataState> {
  CompleteDataCubit() : super(CompleteDataInitial());

  completeData({
    required File carPlate,
    required File personalIdFront,
    required File personalIdBack,
    File? criminalRecord,
    File? drugTest,
  }) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('object');
      emit(CompleteDataStateLoading());

      try {
        print('called');
        FormData formData = FormData.fromMap({
          'car_number_picture': await MultipartFile.fromFile(carPlate.path,
              filename: carPlate.path.split('/').last),
          'personal_id': await MultipartFile.fromFile(personalIdFront.path,
              filename: personalIdFront.path.split('/').last),
          'dahr_card_photo': await MultipartFile.fromFile(personalIdBack.path,
              filename: personalIdBack.path.split('/').last),
          'analysis_photo': drugTest != null
              ? await MultipartFile.fromFile(drugTest.path,
                  filename: drugTest.path.split('/').last)
              : null,
          'criminal': criminalRecord != null
              ? await MultipartFile.fromFile(criminalRecord.path,
                  filename: criminalRecord.path.split('/').last)
              : null,
        });
        final response = await DioHelper.postData(
            path: kCompleteData, token: getUserToken(), data: formData);
        print("response.statusCode ${response.statusCode}");
        print("response.data ${response.data}");
        if (response.statusCode == 200) {
          emit(CompleteDataStateSuccess(message: response.data['message']));
        } else {
          emit(CompleteDataStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(CompleteDataStateError(error: e.toString()));
      }
    } else {
      emit(const CompleteDataStateError(error: 'No Internet'));
    }
  }
}
