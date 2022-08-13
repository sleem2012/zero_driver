part of 'rating_cubit.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingLoaded extends RatingState {}

class RatingLoadingError extends RatingState {
  final String message;

  const RatingLoadingError(this.message);

  @override
  List<Object> get props => [message];
}
