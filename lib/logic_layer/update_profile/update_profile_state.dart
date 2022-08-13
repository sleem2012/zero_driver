part of 'update_profile_cubit.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileStateLoading extends UpdateProfileState {}

class UpdateProfileStateSuccess extends UpdateProfileState {}

class UpdateProfileImageSuccess extends UpdateProfileState {}

class UpdateProfileStateError extends UpdateProfileState {
  const UpdateProfileStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [];
}
