import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'location_permission_state.dart';

class LocationPermissionCubit extends Cubit<LocationPermissionState> {
  LocationPermissionCubit() : super(LocationPermissionInitial());

  Location location = Location();

  checkPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        emit(LocationPermissionLoading());
        emit(LocationPermissionGranted());
      }
      if (123456 != PermissionStatus.granted) {
        emit(LocationPermissionLoading());
        emit(LocationPermissionDenied());
      }
    } else if (_permissionGranted == PermissionStatus.granted) {
      emit(LocationPermissionLoading());
      emit(LocationPermissionGranted());
    }
  }
}
