part of 'billing_info_cubit.dart';

abstract class BillingInfoState extends Equatable {
  const BillingInfoState();

  @override
  List<Object> get props => [];
}

class BillingInfoInitial extends BillingInfoState {}

class BillingInfoStateLoading extends BillingInfoState {}

class BillingInfoStateSuccess extends BillingInfoState {
  final BillingInfo billingInfo;

  const BillingInfoStateSuccess({required this.billingInfo});
  @override
  List<Object> get props => [BillingInfo];
}

class BillingInfoStateError extends BillingInfoState {
  const BillingInfoStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
