import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:driver/injection_container.dart' as di;
part 'change_availabilty_state.dart';

class ChangeAvailabilityCubit extends Cubit<ChangeAvailabiltyState> {
  ChangeAvailabilityCubit() : super(ChangeAvailabiltyInitial());

  // getUserStatus()
  // ??
  bool isOnline = false;

  start() {
    final String? driverId = getUserId();
    isOnline = getUserStatus() ?? false;
    emit(ChangeAvailabiltyLoading());
    di.sl<Socket>().emit(
      'update_status',
      {
        "user_id": driverId,
        "status": isOnline ? 2 : 1,
      },
    );
    saveUserStatus(isOnline);
    emit(const ChangeAvailabiltyLoaded());
  }

  changeAvailability(bool value) {
    emit(Loading2());
    final String? driverId = getUserId();

    emit(ChangeAvailabiltyInitial());
    emit(ChangeAvailabiltyLoading());
    isOnline = value;

    di.sl<Socket>().emit(
      'update_status',
      {
        "user_id": driverId,
        "status": isOnline ? 2 : 1,
      },
    );
    saveUserStatus(isOnline);
    emit(const ChangeAvailabiltyLoaded());
  }
}
