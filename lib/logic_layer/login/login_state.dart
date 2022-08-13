part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateSuccess extends LoginState {
  final String message;

  const LoginStateSuccess({required this.message});
}

class LoginStateError extends LoginState {
  final String error;
  const LoginStateError({required this.error});
}
