import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/utils/enum/loading_state.dart';

class BtnLoadingState extends Equatable {
  final GlobalKey? key;
  final bool isLoading;
  final double? progress;
  final bool enable;
  final bool blockUI;

  const BtnLoadingState({
    this.key,
    this.isLoading = false,
    this.progress,
    this.enable = true,
    this.blockUI = false
  });

  BtnLoadingState copyWith({GlobalKey? key, bool? isLoading, double? progress, bool? enable, bool? blockUI}) {
    return BtnLoadingState(
      key: key ?? this.key,
      isLoading: isLoading ?? this.isLoading,
      progress: isLoading != null ? null : progress ?? this.progress,
      enable: enable ?? this.enable,
      blockUI: blockUI ?? this.blockUI
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [key, isLoading, progress, enable, blockUI];
}

class BtnLoadingBloc extends Cubit<Map<LoadingState, BtnLoadingState>> {
  BtnLoadingBloc() : super({});

  void holdKey({required LoadingState loadingState, required GlobalKey key}) {
    final current = state[loadingState] ?? BtnLoadingState();
    emit({
      ...state,
      loadingState: current.copyWith(key: key),
    });
  }


  void startLoading({required LoadingState loadingState, double? progress, bool? blockUI}) {
    final current = state[loadingState];
    if (current != null) {
      emit({
        ...state,
        loadingState: current.copyWith(
            progress: progress,
            isLoading: progress != null ? null : true,
          blockUI: blockUI
          // enable: true
        ),
      });
    } else {
      emit({
        ...state,
        loadingState: BtnLoadingState(
          isLoading: progress != null ? false : true,
          progress: progress,
          blockUI: blockUI ?? false
          // enable: false,
        ),
      });
    }
  }

  void stopLoading({required LoadingState loadingState}) {
    final current = state[loadingState];
    if(current != null) {
      emit({
        ...state,
        loadingState: current.copyWith(
          isLoading: false,
          blockUI: false
        )
      });
    }
  }

  void enable({required LoadingState loadingState, required bool enable}) {
    final current = state[loadingState] ?? BtnLoadingState();
    emit({
      ...state,
      loadingState: current.copyWith(
        progress: null,
        isLoading: false,
        enable: enable,
      ),
    });
  }

  void remove(LoadingState stateKey) {
    final current = state[stateKey];
    if (current != null) {
      final newState = Map.of(state);
      newState.remove(stateKey);
      emit(newState);
    }
  }
}