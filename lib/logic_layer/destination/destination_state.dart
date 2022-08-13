part of 'destination_cubit.dart';

abstract class DestinationState extends Equatable {
  const DestinationState();

  @override
  List<Object> get props => [];
}

class DestinationInitial extends DestinationState {}

class DestinationLoading extends DestinationState {}

class DestinationLoaded extends DestinationState {}


