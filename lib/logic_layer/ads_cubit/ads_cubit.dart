import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain_layer/models/ads_model/ads_model.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  AdsCubit() : super(AdsInitial());



  getAds({required int type}) async {
    emit(AdsLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response =
            await http.get(Uri.parse('https://taxi.0store.net/api/pages/ads'));
        log("ads response ${response.body}");
        log("ads response ${response.statusCode}");

        if (response.statusCode == 200) {
          AdsModel adsModel = AdsModel.fromJson(jsonDecode(response.body));
          List<Data>? myData =
              adsModel.data!.where((element) => element.type == type).toList();
          log("ads myData $myData");
          log(response.body);
          log('lenght ${myData.length}');
          emit(AdsLoaded(data: myData));
        } else {
          emit(AdsLoadingError(error: '${response.body}'));
        }
      } catch (e) {
        emit(AdsLoadingError(error: e.toString()));
      }
    } else {
      emit(AdsLoadingError(error: 'No Internet'));
    }
  }
}
