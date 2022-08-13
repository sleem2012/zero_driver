part of 'check_profile_cubit.dart';

abstract class CheckProfileState extends Equatable {
  const CheckProfileState();

  @override
  List<Object> get props => [];
}

class CheckProfileInitial extends CheckProfileState {}

class CheckProfileStateLoading extends CheckProfileState {}

class CheckProfileStateSuccess extends CheckProfileState {
  final CheckProfile checkProfile;

  const CheckProfileStateSuccess({required this.checkProfile});
  @override
  List<Object> get props => [checkProfile];
}

class CheckProfileStateError extends CheckProfileState {
  const CheckProfileStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
