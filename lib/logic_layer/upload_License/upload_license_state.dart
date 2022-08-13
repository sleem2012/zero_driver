part of 'upload_license_cubit.dart';

abstract class UploadLicenseState extends Equatable {
  const UploadLicenseState();

  @override
  List<Object?> get props => [];
}

class UploadLicenseInitial extends UploadLicenseState {}

class UploadLicenseLoading extends UploadLicenseState {}

class UploadLicenseSuccess extends UploadLicenseState {
  const UploadLicenseSuccess();
  @override
  List<Object?> get props => [];
}

class UploadLicenseError extends UploadLicenseState {
  final String error;
  const UploadLicenseError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
