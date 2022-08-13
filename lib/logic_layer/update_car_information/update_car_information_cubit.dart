import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'update_car_information_state.dart';

class UpdateCarInformationCubit extends Cubit<UpdateCarInformationState> {
  UpdateCarInformationCubit() : super(UpdateCarInformationInitial());
  updateCarInfo({
    required int serviceType,
    required int carModel,
    required String carModelString,
    required String carColorString,
    required int carColor,
    required String carYear,
    required String carNumber,
    required File frondSide,
    required File backSide,
  }) async {
    emit(UpdateCarInformationLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        FormData formData = FormData.fromMap({
          'front_side_car_license': await MultipartFile.fromFile(frondSide.path,
              filename: frondSide.path.split('/').last),
          'back_side_car_license': await MultipartFile.fromFile(backSide.path,
              filename: backSide.path.split('/').last),
          'car_model_id': carModel,
          'car_year': carYear,
          'car_color': carColor,
          'car_number': carNumber,
          'service_id': serviceType,
        });
        final response = await DioHelper.postData(
            path: kUpdateCarInfo, token: getUserToken(), data: formData);

        if (response.statusCode == 200) {
          print(carModelString);
          saveCarType(serviceType);
          saveCarColor(carColorString);
          saveCarModel(carModelString);
          saveCarNumber(carNumber);

          emit(const UpdateCarInformationSuccess());
        } else {
          emit(UpdateCarInformationError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(UpdateCarInformationError(error: e.toString()));
      }
    } else {
      emit(const UpdateCarInformationError(error: 'No Internet'));
    }
  }
}
