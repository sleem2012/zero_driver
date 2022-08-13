import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:driver/injection_container.dart' as di;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:driver/injection_container.dart' as di;
part 'start_or_finish_state.dart';

class StartOrFinishCubit extends Cubit<StartOrFinishState> {
  StartOrFinishCubit() : super(StartOrFinishInitial());

  emitCancelTrip(int? requestId) {
    print('emit cancel');
    di.sl<Socket>().on(
      'canceled_after_accepted_$requestId',
      (data) {
        print('canceled');
        removeStartDate();
        removeEndDate();
        emit(const CancelTripSuccess());
      },
    );
  }

  arrived(int? requestId) async {
    emit(const DriverArrivedLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          path: kChangeTripStatus,
          token: getUserToken(),
          data: {
            'request_id': requestId,
            'status': 7,
          },
        );
        if (response.statusCode == 200) {
          print("status 200 : $getStartDate()");
          final startDate = getStartDate() ?? DateTime.now().toString();
          final endDate =
              DateTime.now().add(const Duration(minutes: 5)).toString();
          saveStartDate(startDate);
          saveEndTime(endDate);
          print('started trip');
          di.sl<Socket>().emit(
            'waiting_customer',
            {
              'request_id': requestId,
            },
          );

          emit(DriverArrivedSuccess());
        } else {
          emit(DriverArrivedError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(DriverArrivedError(error: e.toString()));
      }
    } else {
      emit(const DriverArrivedError(error: 'No Internet'));
    }
  }

  startTrip(int? requestId) async {
    emit(StartTripStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          path: kChangeTripStatus,
          token: getUserToken(),
          data: {
            'request_id': requestId,
            'status': 3,
          },
        );
        if (response.statusCode == 200) {
          print('started trip');
          di.sl<Socket>().emit(
            'start_trip',
            {
              'request_id': requestId,
              'distance': response.data['data']['distance'].toString(),
              'time': response.data['data']['trip_time'].toString(),
              'image': getUserImage().toString(),
            },
          );
          print(
            response.data['data']['distance'].toString(),
          );
          print(response.data['data']['trip_time'].toString());
          emit(StartTripSuccess());
        } else {
          emit(StartTripStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(StartTripStateError(error: e.toString()));
      }
    } else {
      emit(const StartTripStateError(error: 'No Internet'));
    }
  }

  finishTrip(
    int? requestId,
  ) {
    removeStartDate();
    removeEndDate();
    emit(FinishTripStateLoading());
    di.sl<Socket>().emit(
          'finished_trip',
          requestId,
        );
    emit(FinishTripSuccess());
  }

  cancelTrip(String note, TripInfo? tripInfo) async {
    // kCancelTrip
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          data: {'note': note},
          path: kCancelTrip,
          token: getUserToken(),
        );

        emit(StartTripStateLoading());
        if (response.statusCode == 200) {
          print(response.data['drivers_ids']);
          print(response.data);
          di.sl<Socket>().emit(
            'cancellation',
            {
              "request_id": tripInfo!.requestId,
            },
          );

          di.sl<Socket>().emit(
            'Driver_cancellation',
            {
              "request_id": tripInfo.requestId,
              "longitude_start_point": tripInfo.longitudeStartPoint,
              "latitude_start_point": tripInfo.latitudeStartPoint,
              "longitude_end_point": tripInfo.longitudeEndPoint,
              "latitude_end_point": tripInfo.latitudeEndPoint,
              'car_type': getCarType(),
              'start_name': tripInfo.startName,
              'end_name': tripInfo.endName,
              'note': '$note',
              'client_name': tripInfo.clientName,
              'client_mobile': tripInfo.clientMobile,
              'trip_price': tripInfo.tripPrice,
              'drivers_ids': response.data['data']['drivers_ids']
            },
          );

          emit(CancelTripSuccess());
        } else {
          emit(CancelTripError(errorMessage: '${response.data['message']}'));
        }
      } catch (e) {
        emit(CancelTripError(errorMessage: e.toString()));
      }
    } else {
      emit(CancelTripError(errorMessage: 'No Internet Connection'));
    }
  }
}
