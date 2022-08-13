import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/models/cars_info/cars_info.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain_layer/local/shared_preferences.dart';
import '../../domain_layer/remote/remote.dart';

part 'get_models_state.dart';

class GetModelsCubit extends Cubit<GetModelsState> {
  GetModelsCubit() : super(GetModelsInitial());
  String carYear = '';
  String carColorString = '';
  String carModelString = '';

  String carServiceString = '';

  getGetModels(int carType) async {
    emit(GetModelsStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: 'auth/cars?service_id=3',
          // kGetModels,
          token: getUserToken(),
          query: {
            "service_id": carType.toString(),
          },
        );
        if (response.statusCode == 200) {
          CarsInfo carsInfo = CarsInfo.fromJson(response.data);
          carYear = carsInfo.data!.carYear[0];
          carColorString = carsInfo.data!.carColor[0].name;
          carModelString = carsInfo.data!.carModel[0].name;
          // log(carsInfo.data.toString());
          carServiceString = carsInfo.data!.service[0].name;
          log('models ${carsInfo.data!.carColor.length}');
          log('models  ${carsInfo.data!.carModel.length}');
          log('models  ${carsInfo.data!.carYear.length}');
          log('models  ${carsInfo.data!.service.length}');

          emit(GetModelsStateSuccess(carsModelInfo: carsInfo));
        } else {
          emit(GetModelsStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(GetModelsStateError(error: e.toString()));
      }
    } else {
      emit(const GetModelsStateError(error: 'No Internet'));
    }
  }
}
