import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarState extends Equatable {
  final int index;

  const BottomNavBarState(this.index);

  @override
  List<Object> get props => [index];
}

class BottomNavBarBloc extends Cubit<BottomNavBarState> {
  BottomNavBarBloc() : super(const BottomNavBarState(0));

  void setIndex({required int index}) => emit(BottomNavBarState(index));
}
