part of 'help_cubit.dart';

abstract class HelpState extends Equatable {
  const HelpState();

  @override
  List<Object> get props => [];
}

class HelpInitial extends HelpState {}

class GetHelpDataLoading extends HelpState {}

class GetHelpDataSuc extends HelpState {
  final String name;
  final String description;
  const GetHelpDataSuc({required this.name, required this.description});
  @override
  List<Object> get props => [name, description];
}

class GetHelpDataError extends HelpState {
  final String error;
  const GetHelpDataError(this.error);
  @override
  List<Object> get props => [error];
}
