import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

part 'upload_license_state.dart';

class UploadLicenseCubit extends Cubit<UploadLicenseState> {
  UploadLicenseCubit() : super(UploadLicenseInitial());

  File image1 = File('');
  File image2 = File('');

  pickImage1(
    BuildContext context,
  ) async {
    emit(UploadLicenseLoading());
    Future.delayed(Duration(milliseconds: 500));

    final pickedFile = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: const Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: ImgSource.Gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 900,
        barrierDismissible: true,
        galleryText: const Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    if (pickedFile != null) {
      image1 = File(pickedFile.path);
      print('$image1 image1');
      emit(const UploadLicenseSuccess());
    } else {
      emit(UploadLicenseInitial());
    }
  }

  pickImage2(
    BuildContext context,
  ) async {
    Future.delayed(Duration(milliseconds: 500));
    emit(UploadLicenseLoading());

    final pickedFile = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: const Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: ImgSource.Gallery,
        barrierDismissible: true,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 900,
        galleryText: const Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    if (pickedFile != null) {
      image2 = File(pickedFile.path);
      emit(const UploadLicenseSuccess());
    }
  }
}
