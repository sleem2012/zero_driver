import 'package:bloc/bloc.dart';
import 'package:driver/domain_layer/remote/end_point.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../domain_layer/local/shared_preferences.dart';
import '../../domain_layer/remote/remote.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingInitial());

  rateUser(double rating, String note, String tripId) async {
    emit(RatingLoading());
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      try {
        final response = await DioHelper.postData(
          path: kRatingEndpoint,
          token: getUserToken(),
          data: {
            "request_id": tripId,
            "rating": rating,
            "note": note,
            "type": 2,
          },
        );

        if (response.statusCode == 200) {
          emit(RatingLoaded());
        } else {
          emit(RatingLoadingError(response.data['message']));
        }
      } catch (e) {
        emit(RatingLoadingError(e.toString()));
      }
    } else {
      emit(const RatingLoadingError('No Internet'));
    }
  }
}
