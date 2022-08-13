import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

part 'upload_profile_image_state.dart';

class UploadProfileImageCubit extends Cubit<UploadProfileImageState> {
  UploadProfileImageCubit() : super(UploadProfileImageInitial());
  String selectedFileName = '';
  String selectedFilePath = '';
  String imageLink = '';

  File image = File('');
  pickImage(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 500));

    final pickedFile = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: Icon(
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
        galleryText: Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(UploadImageSuccess(image: File(pickedFile.path)));
    }
  }
}
