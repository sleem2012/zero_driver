part of 'latest_addresses_cubit.dart';

abstract class LatestAddressesState extends Equatable {
  const LatestAddressesState();

  @override
  List<Object> get props => [];
}

class LatestAddressesInitial extends LatestAddressesState {}



class LatestAddressStateLoading extends LatestAddressesState {}

class LatestAddressStateSuccess extends LatestAddressesState {
  final String message;

  const LatestAddressStateSuccess({required this.message});
}

class LatestAddressStateError extends LatestAddressesState {
  final String error;
  const LatestAddressStateError({required this.error});
}
