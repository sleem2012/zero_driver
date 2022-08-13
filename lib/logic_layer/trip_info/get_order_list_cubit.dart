import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/trip_info/trip_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:driver/injection_container.dart' as di;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:socket_io_client/socket_io_client.dart';
part 'get_order_list_state.dart';

class GetOrderListCubit extends Cubit<GetOrderListState> {
  GetOrderListCubit() : super(GetOrderListInitial());
  List<TripInfo> tripsInfo = [];

  removeTrip(int? requestId) {
    emit(GetOrderListLoading());
    DioHelper.postData(
      data: {
        'request_id': requestId,
        'status': 2,
      },
      token: getUserToken(),
      path: kChangeTripStatus,
    ).then((value) {
      tripsInfo.removeWhere((element) => element.requestId == requestId);
      emit(GetOrderListLoaded(tripsInfo: tripsInfo));
    }).catchError((e) {
      if (e is DioError) {
        emit(GetOrderListError(errorMessage: '${e.response!.data['message']}'));
      } else {}
    });
  }

  getOrderList() async {
    final String? driverId = getUserId();
    emit(GetOrderListInitial());

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        emit(GetOrderListLoading());
        final response = await DioHelper.getData(
          path: kOrderList,
          token: getUserToken(),
        );

        if (response.statusCode == 200) {
    
          Iterable l = response.data['data'];
          List<TripInfo> myList =
              List<TripInfo>.from(l.map((model) => TripInfo.fromJson(model)));
          log("api myList: $myList");
          tripsInfo = myList;

          if (tripsInfo.isNotEmpty) {
            emit(GetOrderListLoaded(tripsInfo: tripsInfo));
          } else {
            emit(GetOrderListInitial());
          }
        } else {
          print('first');
          emit(GetOrderListInitial());
        }
      } catch (e) {
        print(e.toString());
        print('second');
        emit(GetOrderListInitial());
      }
    } else {
      print('thirds');
      emit(GetOrderListInitial());
    }

    // di.sl<Socket>().emit('track_cars', {
    //   "longitude": "31.1928975",
    //   "latitude": "30.0528297",
    //   "user_id": 737,
    //   "zzzz": getUserId(),
    //   "mmmm": getUserId(),
    // });
    di.sl<Socket>().on(
      'c',
      (data) {
        print(data);
      },
    );
    di.sl<Socket>().on(
      'driver_$driverId',
      (data) {
        log("Socket ${data.toString()}");
        emit(GetOrderListLoading());
        if (!tripsInfo.contains(TripInfo.fromJson(data))) {
          tripsInfo.add(TripInfo.fromJson(data));
        }
        log(tripsInfo.toString());
        emit(
          GetOrderListLoaded(
            tripsInfo: tripsInfo,
          ),
        );
      },
    );
    di.sl<Socket>().on(
      'remove_trip_driver',
      (data) {
        tripsInfo.removeWhere(
            (tripInfo) => tripInfo.requestId == data['request_id']);
        emit(GetOrderListLoading());
        emit(
          GetOrderListLoaded(
            tripsInfo: tripsInfo,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
