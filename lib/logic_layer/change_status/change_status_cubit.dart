import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'change_status_state.dart';

class ChangeStatusCubit extends Cubit<ChangeStatusState> {
  ChangeStatusCubit() : super(ChangeStatusInitial());

  /// Get ChangeStatus
  refuse(int? requestId, int? statusId) {
    emit(ChangeStatusStateLoading());
    DioHelper.postData(
      data: {
        'request_id': requestId,
        'status': statusId,
      },
      token: getUserToken(),
      path: kChangeTripStatus,
    ).then((value) {
      emit(RefuseTripSuccess());
    }).catchError((e) {
      if (e is DioError) {
        print(e);
        emit(ChangeStatusStateError(error: '${e.response!.data['message']}'));
      } else {}
    });
  }

  acceptTrip(int? requestId, int? statusId) async {
    emit(ChangeStatusStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          path: kChangeTripStatus,
          token: getUserToken(),
          data: {
            'request_id': requestId,
            'status': statusId,
          },
        );
        if (response.statusCode == 200) {
          emit(
            AcceptTripSuccess(
                distance: response.data['data']['distance'],
                tripTime: response.data['data']['trip_time'],
                haveTrip: response.data['data']['have_trip'],
            ),
          );
        } else {
          emit(ChangeStatusStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(ChangeStatusStateError(error: e.toString()));
      }
    } else {
      emit(const ChangeStatusStateError(error: 'No Internet'));
    }
  }

  // start(int? requestId, int? statusId) async {
  //   emit(ChangeStatusStateLoading());

  //   bool result = await InternetConnectionChecker().hasConnection;
  //   if (result == true) {
  //     try {
  //       final response = await DioHelper.postData(
  //         path: kChangeTripStatus,
  //         token: getUserToken(),
  //         data: {
  //           'request_id': requestId,
  //           'status': 3,
  //         },
  //       );
  //       if (response.statusCode == 200) {
  //         emit(AcceptTripSuccess(
  //             distance: response.data['data']['distance'],
  //             tripTime: response.data['data']['trip_time']));
  //       } else {
  //         emit(ChangeStatusStateError(error: '${response.data['message']}'));
  //       }
  //     } catch (e) {
  //       emit(ChangeStatusStateError(error: e.toString()));
  //     }
  //   } else {
  //     emit(const ChangeStatusStateError(error: 'No Internet'));
  //   }
  // }

  finish(int? requestId, int? statusId) async {
    emit(ChangeStatusStateLoading());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          path: kChangeTripStatus,
          token: getUserToken(),
          data: {
            'request_id': requestId,
            'status': 4,
          },
        );
        if (response.statusCode == 200) {
          print(response.data);
          emit(
            AcceptTripSuccess(
                distance: response.data['data']['distance'],
                tripTime: response.data['data']['trip_time'],
                haveTrip: response.data['data']['have_trip'],
            ),
          );
        } else {
          emit(ChangeStatusStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(ChangeStatusStateError(error: e.toString()));
      }
    } else {
      emit(const ChangeStatusStateError(error: 'No Internet'));
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
