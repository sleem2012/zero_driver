part of 'user_info_cubit.dart';

abstract class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object> get props => [];
}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final UserInfo userInfo;
  const UserInfoLoaded({
    required this.userInfo,
  });
  @override
  List<Object> get props => [userInfo];
}

class UserInfoError extends UserInfoState {
  final String errorMessage;
  const UserInfoError({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [errorMessage];
}
