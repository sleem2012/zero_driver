import 'package:driver/logic_layer/location_permission/location_permission_cubit.dart';
import 'package:driver/ui_layer/widgets/google_maps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-scree';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LocationPermissionCubit()..checkPermission(),
        child: BlocBuilder<LocationPermissionCubit, LocationPermissionState>(
          builder: (context, state) {
            // print(state);
            // if (state is LocationPermissionGranted) {
            // }
            // if (state is LocationPermissionDenied) {
            //   return Text('denied');
            // }

            return GoogleMapsWidget();
          },
        ),
      ),
    );
  }
}
