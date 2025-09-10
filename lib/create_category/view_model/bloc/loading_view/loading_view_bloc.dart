import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/utils/enum/loading_type.dart';

class LoadingViewState extends Equatable {

  String? title;
  LoadingType loadingType;

  LoadingViewState({this.loadingType = LoadingType.none, this.title});

  LoadingViewState copyWith({LoadingType? loadingType, String? title}) {
    return LoadingViewState(
      loadingType: loadingType ?? this.loadingType,
      title: title ?? this.title
    );
  }

  @override
  List<Object> get props => [loadingType, ?title];
}

class LoadingViewBloc extends Cubit<LoadingViewState> {
  LoadingViewBloc() : super(LoadingViewState());

  void setLoading({required LoadingType loadingType, String? title}) {
    emit(state.copyWith(loadingType: loadingType,title: title));
  }

  void stopLoading() {
    emit(state.copyWith(loadingType: LoadingType.none));
  }
}