part of 'get_models_cubit.dart';

abstract class GetModelsState extends Equatable {
  const GetModelsState();

  @override
  List<Object> get props => [];
}

class GetModelsInitial extends GetModelsState {}

class GetModelsStateLoading extends GetModelsState {}

class GetModelsStateSuccess extends GetModelsState {
  final CarsInfo carsModelInfo;

  const GetModelsStateSuccess({required this.carsModelInfo});
  @override
  List<Object> get props => [carsModelInfo];
}

class GetModelsStateError extends GetModelsState {
  const GetModelsStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
