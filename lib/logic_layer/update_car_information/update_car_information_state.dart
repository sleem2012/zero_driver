part of 'update_car_information_cubit.dart';

abstract class UpdateCarInformationState extends Equatable {
  const UpdateCarInformationState();

  @override
  List<Object> get props => [];
}

class UpdateCarInformationInitial extends UpdateCarInformationState {}

class UpdateCarInformationLoading extends UpdateCarInformationState {}

class UpdateCarInformationSuccess extends UpdateCarInformationState {
  const UpdateCarInformationSuccess();
  @override
  List<Object> get props => [];
}

class UpdateCarInformationError extends UpdateCarInformationState {
  const UpdateCarInformationError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
