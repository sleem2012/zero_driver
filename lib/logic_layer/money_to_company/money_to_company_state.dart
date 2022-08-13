part of 'money_to_company_cubit.dart';

abstract class MoneyToCompanyState extends Equatable {
  const MoneyToCompanyState();

  @override
  List<Object> get props => [];
}

class MoneyToCompanyInitial extends MoneyToCompanyState {}

class MoneyToCompanyStateLoading extends MoneyToCompanyState {}

class MoneyToCompanyStateSuccess extends MoneyToCompanyState {
  final String message;
  const MoneyToCompanyStateSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [];
}

class MoneyToCompanyStateError extends MoneyToCompanyState {
  const MoneyToCompanyStateError({required this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
