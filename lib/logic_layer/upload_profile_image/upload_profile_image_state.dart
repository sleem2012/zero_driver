part of 'upload_profile_image_cubit.dart';

abstract class UploadProfileImageState extends Equatable {
  const UploadProfileImageState();

  @override
  List<Object?> get props => [];
}

class UploadProfileImageInitial extends UploadProfileImageState {}

class UploadImageLoading extends UploadProfileImageState {}

class UploadImageSuccess extends UploadProfileImageState {
  final File image;

  const UploadImageSuccess({
    required this.image,
  });
  @override
  List<Object?> get props => [
        image,
      ];
}

class UploadImageError extends UploadProfileImageState {
  final String error;
  const UploadImageError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
