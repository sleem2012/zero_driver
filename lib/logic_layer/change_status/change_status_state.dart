part of 'change_status_cubit.dart';

abstract class ChangeStatusState extends Equatable {
  const ChangeStatusState();

  @override
  List<Object> get props => [];
}

class ChangeStatusInitial extends ChangeStatusState {}

class ChangeStatusStateLoading extends ChangeStatusState {}

class AcceptTripSuccess extends ChangeStatusState {
  final num distance;
  final String tripTime;
  final bool haveTrip;
  const AcceptTripSuccess({
    required this.distance,
    required this.tripTime,
    required this.haveTrip,
  });
  @override
  List<Object> get props => [];
}

class RefuseTripSuccess extends ChangeStatusState {
  const RefuseTripSuccess();
  @override
  List<Object> get props => [];
}

class ChangeStatusStateError extends ChangeStatusState {
  const ChangeStatusStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
