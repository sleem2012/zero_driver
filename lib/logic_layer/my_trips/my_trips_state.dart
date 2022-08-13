part of 'my_trips_cubit.dart';

abstract class MyTripsState extends Equatable {
  const MyTripsState();

  @override
  List<Object> get props => [];
}

class MyTripsInitial extends MyTripsState {}

class MyTripsStateLoading extends MyTripsState {}

class MyTripsStateSuccess extends MyTripsState {
  final MyTrips myTrips;

  const MyTripsStateSuccess({required this.myTrips});
  @override
  List<Object> get props => [myTrips];
}

class MyTripsStateError extends MyTripsState {
  const MyTripsStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
