part of 'support_cubit.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object> get props => [];
}

class SupportInitial extends SupportState {}

class SupportStateLoading extends SupportState {}

class SupportStateSuccess extends SupportState {
  final String message;
  const SupportStateSuccess(this.message);
}

class SupportStateError extends SupportState {
  final String error;
  const SupportStateError(this.error);
}
