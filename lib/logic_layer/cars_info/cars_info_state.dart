part of 'cars_info_cubit.dart';

abstract class CarsInfoState extends Equatable {
  const CarsInfoState();

  @override
  List<Object> get props => [];
}

class CarsInfoInitial extends CarsInfoState {}

class CarsInfoStateLoading extends CarsInfoState {}

class CarsInfoStateSuccess extends CarsInfoState {
  final CarsInfo carsInfo;

  const CarsInfoStateSuccess({required this.carsInfo});
  @override
  List<Object> get props => [carsInfo];
}

class CarsInfoStateError extends CarsInfoState {
  const CarsInfoStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
