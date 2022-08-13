part of 'sign_up_cubit.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpStateLoading extends SignUpState {}

class SignUpStateSuccess extends SignUpState {
  final String message;
  const SignUpStateSuccess({required this.message});
}

class SignUpStateError extends SignUpState {
  final String errorMessage;
  const SignUpStateError({required this.errorMessage});
}
