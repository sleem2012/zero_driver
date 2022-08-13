import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/local/shared_preferences.dart';
import 'package:driver/domain_layer/models/cars_info/cars_info.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:driver/domain_layer/remote/remote.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'cars_info_state.dart';

class CarsInfoCubit extends Cubit<CarsInfoState> {
  String carYear = '';
  String carColorString = '';
  String carModelString = '';

  String carServiceString = '';

  CarsInfoCubit() : super(CarsInfoInitial());
  getCarsInfo() async {
    emit(CarsInfoStateLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.getData(
          path: kCarsInfo,
          token: getUserToken(),
        );
        if (response.statusCode == 200) {
          CarsInfo carsInfo = CarsInfo.fromJson(response.data);
          carYear = carsInfo.data!.carYear[0];
          carColorString = carsInfo.data!.carColor[0].name;
          carModelString = carsInfo.data!.carModel[0].name;

          carServiceString = carsInfo.data!.service[0].name;

          emit(CarsInfoStateSuccess(carsInfo: carsInfo));
        } else {
          emit(CarsInfoStateError(error: '${response.data['message']}'));
        }
      } catch (e) {
        emit(CarsInfoStateError(error: e.toString()));
      }
    } else {
      emit(const CarsInfoStateError(error: 'No Internet'));
    }
  }
}
