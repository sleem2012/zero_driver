import 'package:driver/logic_layer/billing_info/billing_info_cubit.dart';
import 'package:driver/logic_layer/check_profile/check_profile_cubit.dart';
import 'package:driver/logic_layer/my_trips/my_trips_cubit.dart';
import 'package:driver/logic_layer/trip_info/get_order_list_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'logic_layer/cars_info/cars_info_cubit.dart';
import 'logic_layer/change_availability/change_availabilty_cubit.dart';
import 'logic_layer/change_status/change_status_cubit.dart';

final sl = GetIt.instance;

void setUp() {
  sl.registerSingleton<Socket>(
    io(
      // 'http://162.214.120.217:9060/',
      'http://taxi.0store.net:9060/',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          // .enableForceNewConnection()
          .disableAutoConnect() // disable auto-connection
          .build(),
    ),
  );
  sl.registerFactory<GetOrderListCubit>(
    () => GetOrderListCubit(),
  );
  sl.registerSingleton<CarsInfoCubit>(CarsInfoCubit());
  sl.registerFactory<ChangeStatusCubit>(() => ChangeStatusCubit());
  sl.registerFactory<ChangeAvailabilityCubit>(() => ChangeAvailabilityCubit());
  sl.registerFactory<MyTripsCubit>(() => MyTripsCubit());
  sl.registerFactory<BillingInfoCubit>(() => BillingInfoCubit());
  sl.registerFactory<CheckProfileCubit>(() => CheckProfileCubit());
}
