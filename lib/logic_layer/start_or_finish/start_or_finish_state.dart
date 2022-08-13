part of 'start_or_finish_cubit.dart';

abstract class StartOrFinishState extends Equatable {
  const StartOrFinishState();

  @override
  List<Object> get props => [];
}

class StartOrFinishInitial extends StartOrFinishState {}

class StartTripStateLoading extends StartOrFinishState {}

class StartTripStateError extends StartOrFinishState {
  final String error;
  const StartTripStateError({required this.error});
}

class StartTripSuccess extends StartOrFinishState {
  const StartTripSuccess();
  @override
  List<Object> get props => [];
}

class DriverArrivedLoading extends StartOrFinishState {
  const DriverArrivedLoading();
  @override
  List<Object> get props => [];
}

class DriverArrivedSuccess extends StartOrFinishState {
  const DriverArrivedSuccess();
  @override
  List<Object> get props => [];
}

class DriverArrivedError extends StartOrFinishState {
  final String error;
  const DriverArrivedError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}

class FinishTripStateLoading extends StartOrFinishState {}

class FinishTripSuccess extends StartOrFinishState {
  const FinishTripSuccess();
  @override
  List<Object> get props => [];
}

class CancelTripSuccess extends StartOrFinishState {
  const CancelTripSuccess();
  @override
  List<Object> get props => [];
}

class CancelTripError extends StartOrFinishState {
  final String errorMessage;
  const CancelTripError({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [];
}
