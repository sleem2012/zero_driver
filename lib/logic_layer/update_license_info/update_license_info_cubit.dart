import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

part 'update_license_info_state.dart';

class UpdateLicenseInfoCubit extends Cubit<UpdateLicenseInfoState> {
  UpdateLicenseInfoCubit() : super(UpdateLicenseInfoInitial());
  updateUserInfo({
    required String licenseNumber,
    required String expiryDate,
    required File frondSide,
    required File backSide,
  }) async {
    print('last date $expiryDate');
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formattedDate = formatter.format(expiryDate);
    emit(UpdateCarInformationLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        FormData formData = FormData.fromMap({
          'front_side_license': await MultipartFile.fromFile(frondSide.path,
              filename: frondSide.path.split('/').last),
          'back_side_license': await MultipartFile.fromFile(backSide.path,
              filename: backSide.path.split('/').last),
          'license_number': licenseNumber,
          'expiry_date': expiryDate,
        });
        final response = await DioHelper.postData(
            path: kUpdateLicenseInfo, token: getUserToken(), data: formData);
        if (response.statusCode == 200) {
          emit(const UpdateCarInformationSuccess());
        } else {
          print(response.data['message']);
          emit(UpdateCarInformationError(error: '${response.data['message']}'));
        }
      } catch (e) {
        print(e);
        emit(UpdateCarInformationError(error: e.toString()));
      }
    } else {
      emit(const UpdateCarInformationError(error: 'No Internet'));
    }
  }
}
