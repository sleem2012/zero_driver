part of 'phone_verfication_cubit.dart';

abstract class PhoneVerficationState extends Equatable {
  const PhoneVerficationState();

  @override
  List<Object> get props => [];
}

class PhoneVerficationInitial extends PhoneVerficationState {}

class PhoneVerficationSent extends PhoneVerficationState {}

class PhoneVerficationFailed extends PhoneVerficationState {
  final String errorMessage;
  const PhoneVerficationFailed({
    required this.errorMessage,
  });
}
