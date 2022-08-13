part of 'upload_car_license_cubit.dart';

abstract class UploadCarLicenseState extends Equatable {
  const UploadCarLicenseState();

  @override
  List<Object?> get props => [];
}

class UploadCarLicenseInitial extends UploadCarLicenseState {}

class UploadLicenseLoading extends UploadCarLicenseState {}

class UploadLicenseSuccess extends UploadCarLicenseState {
  const UploadLicenseSuccess();
  @override
  List<Object?> get props => [];
}

class UploadLicenseError extends UploadCarLicenseState {
  final String error;
  const UploadLicenseError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
