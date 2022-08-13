import 'package:driver/domain_layer/models/trip_info/trip_info.dart';

abstract class GetCurrentTripStates {}

class CurrentTripStateInitial extends GetCurrentTripStates {}

//states of driver current  trip
class GetCurrentTripStateLoading extends GetCurrentTripStates {}

class GetCurrentTriStateSuc extends GetCurrentTripStates {}

class GetCurrentTripStateError extends GetCurrentTripStates {
  dynamic error;
  GetCurrentTripStateError(this.error);
}

class CurrentTripAccepted extends GetCurrentTripStates {
  TripInfo? tripInfo;
  CurrentTripAccepted(this.tripInfo);
}

class CurrentTripStarted extends GetCurrentTripStates {
  TripInfo? tripInfo;
  bool haveTrip ;
  CurrentTripStarted(this.tripInfo,this.haveTrip);
}
