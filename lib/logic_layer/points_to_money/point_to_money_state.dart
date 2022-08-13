part of 'point_to_money_cubit.dart';

abstract class PointToMoneyState extends Equatable {
  const PointToMoneyState();

  @override
  List<Object> get props => [];
}

class PointToMoneyInitial extends PointToMoneyState {}

class PointToMoneyStateLoading extends PointToMoneyState {}

class PointToMoneyStateSuccess extends PointToMoneyState {
  final String message;
  const PointToMoneyStateSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [];
}

class PointToMoneyStateError extends PointToMoneyState {
  const PointToMoneyStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
