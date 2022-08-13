import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());
  updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  }) async {
    emit(UpdateProfileStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        FormData formData = FormData.fromMap({
          "image": image!.path != null && image.path != ''
              ? await MultipartFile.fromFile(image.path,
                  filename: image.path.split('/').last)
              : '',
          'name': name,
          'mobile': phone,
          'email': email,
          'password': ''
        });

        final response = await DioHelper.postData(
          path: kUpdateProfile,
          token: getUserToken(),
          data: image.path == null
              ? {'name': name, 'mobile': phone, 'email': email, 'password': ''}
              : formData,
        );

        if (response.statusCode == 200) {
          saveUserName(name);
          saveUserPhone(phone);
          saveUserImage(response.data['data']['image']);
          emit(UpdateProfileStateSuccess());
        } else {
          emit(UpdateProfileStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        print(e);
        emit(UpdateProfileStateError(error: e.toString()));
      }
    } else {
      emit(const UpdateProfileStateError(error: 'No Internet'));
    }

    //   FormData formData = FormData.fromMap({
    //     "file": image!.path != null && image.path != ''
    //         ? await MultipartFile.fromFile(image.path,
    //             filename: image.path.split('/').last)
    //         : '',
    //     'name': name,
    //     'phone': phone,
    //     'email': email,
    //   });
    // DioHelper.postData(
    //   path: kUpdateProfile,
    //   token: getUserToken(),
    //   data: image.path == null
    //       ? {
    //           'name': name,
    //           'phone': phone,
    //           'email': email,
    //         }
    //       : formData,
    //   ).then((value) {
    //     emit(UpdateProfileStateSuccess());
    //   }).catchError((e) {
    //     if (e is DioError) {
    //       emit(UpdateProfileStateError(error: '${e.response!.data['message']}'));
    //     } else {}
    //   });
  }
}
