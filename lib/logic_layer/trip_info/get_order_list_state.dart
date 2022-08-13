part of 'get_order_list_cubit.dart';

abstract class GetOrderListState extends Equatable {
  const GetOrderListState();

  @override
  List<Object> get props => [];
}

class GetOrderListInitial extends GetOrderListState {
  @override
  List<Object> get props => [];
}

class GetOrderListLoading extends GetOrderListState {
  @override
  List<Object> get props => [];
}

class GetOrderListLoaded extends GetOrderListState {
  final List<TripInfo> tripsInfo;
  const GetOrderListLoaded({
    required this.tripsInfo,
  });
  @override
  List<Object> get props => [tripsInfo];
}

class GetOrderListError extends GetOrderListState {
  final String errorMessage;
  const GetOrderListError({
    required this.errorMessage,
  });
}
