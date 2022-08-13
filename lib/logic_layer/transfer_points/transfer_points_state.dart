part of 'transfer_points_cubit.dart';

abstract class TransferPointsState extends Equatable {
  const TransferPointsState();

  @override
  List<Object> get props => [];
}

class TransferPointsInitial extends TransferPointsState {}

class TransferPointsStateLoading extends TransferPointsState {}

class TransferPointsStateSuccess extends TransferPointsState {
  final String message;
  const TransferPointsStateSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [];
}

class TransferPointsStateError extends TransferPointsState {
  const TransferPointsStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
