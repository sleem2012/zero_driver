part of 'ads_cubit.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object?> get props => [];
}

class AdsInitial extends AdsState {
  @override
  List<Object> get props => [];
}

class AdsLoading extends AdsState {
  @override
  List<Object> get props => [];
}

class AdsLoaded extends AdsState {
  final List<Data>? data;
  AdsLoaded({
    required this.data,
  });
  @override
  List<Object?> get props => [data];
}

class AdsLoadingError extends AdsState {
  final String error;
  AdsLoadingError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
