part of 'complete_data_cubit.dart';

abstract class CompleteDataState extends Equatable {
  const CompleteDataState();

  @override
  List<Object> get props => [];
}

class CompleteDataInitial extends CompleteDataState {}

class CompleteDataStateLoading extends CompleteDataState {}

class CompleteDataStateSuccess extends CompleteDataState {
  final String message;
  const CompleteDataStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class CompleteDataStateError extends CompleteDataState {
  const CompleteDataStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
