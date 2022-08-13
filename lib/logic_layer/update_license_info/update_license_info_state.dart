part of 'update_license_info_cubit.dart';

abstract class UpdateLicenseInfoState extends Equatable {
  const UpdateLicenseInfoState();

  @override
  List<Object> get props => [];
}

class UpdateLicenseInfoInitial extends UpdateLicenseInfoState {}

class UpdateCarInformationLoading extends UpdateLicenseInfoState {}

class UpdateCarInformationSuccess extends UpdateLicenseInfoState {
  const UpdateCarInformationSuccess();
  @override
  List<Object> get props => [];
}

class UpdateCarInformationError extends UpdateLicenseInfoState {
  const UpdateCarInformationError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
