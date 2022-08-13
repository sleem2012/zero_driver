part of 'request_profit_cubit.dart';

abstract class RequestProfitState extends Equatable {
  const RequestProfitState();

  @override
  List<Object> get props => [];
}

class RequestProfitInitial extends RequestProfitState {}

class RequestProfitLoading extends RequestProfitState {}

class RequestProfitLoaded extends RequestProfitState {
  final String message;
 const RequestProfitLoaded({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class RequestProfitLoadingError extends RequestProfitState {
  final String message;

  const RequestProfitLoadingError(this.message);

  @override
  List<Object> get props => [message];
}
