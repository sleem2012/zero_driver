part of 'bottom_nav_bar_cubit.dart';

abstract class BottomNavBarState extends Equatable {
  const BottomNavBarState();

  @override
  List<Object> get props => [];
}

class BottomNavBarInitial extends BottomNavBarState {}

class IndexLoading extends BottomNavBarState {}

class IndexChanged extends BottomNavBarState {}
