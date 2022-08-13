import 'package:bloc/bloc.dart';
import 'package:driver/ui_layer/screens/earning_screen.dart/earning_screen.dart';
import 'package:driver/ui_layer/screens/home/home_screen.dart';
import 'package:driver/ui_layer/screens/my_trips/my_trips_screen.dart';
import 'package:driver/ui_layer/screens/orders_list/orders_list_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarInitial());

  ///
  static BottomNavBarCubit get(BuildContext context) =>
      BlocProvider.of(context);

  /// pages
  final List<Widget> widgetOptions = <Widget>[
    // const HomeScreen(),
    const OrdersListScreen(),
    const MyTripsScreen(),
  ];

  /// initial index
  int currentIndex = 0;

  /// method to change index
  changeIndex(int index) {
    currentIndex = index;
    emit(IndexLoading());
    emit(IndexChanged());
  }
}
