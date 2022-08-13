part of 'transfer_money_cubit.dart';

abstract class TransferMoneyState extends Equatable {
  const TransferMoneyState();

  @override
  List<Object> get props => [];
}

class TransferMoneyInitial extends TransferMoneyState {}

class TransferMoneyStateLoading extends TransferMoneyState {}

class TransferMoneyStateSuccess extends TransferMoneyState {
  final String message;
  const TransferMoneyStateSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [];
}

class TransferMoneyStateError extends TransferMoneyState {
  const TransferMoneyStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
