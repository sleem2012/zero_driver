part of 'points_cubit.dart';

abstract class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object> get props => [];
}

class PointsInitial extends PointsState {}

class PointsStateLoading extends PointsState {}

class PointsStateSuccess extends PointsState {
  final Points points;

  const PointsStateSuccess({required this.points});
  @override
  List<Object> get props => [points];
}

class PointsStateError extends PointsState {
  const PointsStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
