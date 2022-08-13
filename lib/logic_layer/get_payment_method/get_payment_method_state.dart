part of 'get_payment_method_cubit.dart';

abstract class GetPaymentMethodState extends Equatable {
  const GetPaymentMethodState();

  @override
  List<Object> get props => [];
}

class GetPaymentMethodInitial extends GetPaymentMethodState {}

class GetPaymentMethodStateLoading extends GetPaymentMethodState {}

class GetPaymentMethodStateSuccess extends GetPaymentMethodState {
  const GetPaymentMethodStateSuccess();
  @override
  List<Object> get props => [];
}

class GetPaymentMethodStateError extends GetPaymentMethodState {
  const GetPaymentMethodStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
