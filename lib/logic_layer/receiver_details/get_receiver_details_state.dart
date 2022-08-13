part of 'get_receiver_details_cubit.dart';

abstract class GetReceiverDetailsState extends Equatable {
  const GetReceiverDetailsState();

  @override
  List<Object> get props => [];
}

class GetReceiverDetailsInitial extends GetReceiverDetailsState {}

class GetReceiverStateLoading extends GetReceiverDetailsState {}

class GetReceiverStateSuccess extends GetReceiverDetailsState {
  final String message;
  const GetReceiverStateSuccess({
    required this.message,
  });
}

class GetReceiverStateError extends GetReceiverDetailsState {
  final String errorMessage;
  const GetReceiverStateError({
    required this.errorMessage,
  });
}
