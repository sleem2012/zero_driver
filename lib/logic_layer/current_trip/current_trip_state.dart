part of 'current_trip_cubit.dart';

abstract class CurrentTripState extends Equatable {
  const CurrentTripState();

  @override
  List<Object> get props => [];
}

class CurrentTripInitial extends CurrentTripState {}

//states of driver current  trip
class GetCurrentTripStateLoading extends CurrentTripState {}

class GetCurrentTriStateSuc extends CurrentTripState {}

class GetCurrentTripStateError extends CurrentTripState {
  final String error;
  const GetCurrentTripStateError({required this.error});
}

class CurrentTripAccepted extends CurrentTripState {
  final TripInfo? tripInfo;
  const CurrentTripAccepted({required this.tripInfo});
}

class CurrentTripStarted extends CurrentTripState {
  final TripInfo? tripInfo;
  bool haveTrip ;
  bool haveNewTrip ;
   CurrentTripStarted({required this.tripInfo,required this.haveTrip,required this.haveNewTrip});
}

class CurrentTripDriverArrived extends CurrentTripState {
  final TripInfo? tripInfo;
  const CurrentTripDriverArrived({
    required this.tripInfo,
  });
}
