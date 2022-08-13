part of 'upload_complete_data_cubit.dart';

abstract class UploadCompleteDataState extends Equatable {
  const UploadCompleteDataState();

  @override
  List<Object?> get props => [];
}

class UploadCompleteDataInitial extends UploadCompleteDataState {}

class UploadLicenseLoading extends UploadCompleteDataState {}

class UploadLicenseSuccess extends UploadCompleteDataState {
  const UploadLicenseSuccess();
  @override
  List<Object?> get props => [];
}

class UploadLicenseError extends UploadCompleteDataState {
  final String error;
  const UploadLicenseError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
