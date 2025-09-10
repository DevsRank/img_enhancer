
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/config/sqfl/model/db_model.dart';
import 'package:image_enhancer_app/config/sqfl/singleton/sqfl_db.dart';
import 'package:image_enhancer_app/utils/enum/table_name.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';

class ImgUtilsHistoryState extends Equatable {
  final bool isLoading;
  final bool success;
  final String msg;
  final bool hasMore;
  final int page;
  final int limit;
  final List<Map<String, dynamic>> dataList;

  ImgUtilsHistoryState({
    this.isLoading = false,
    this.success = false,
    this.msg = "",
    this.hasMore = true,
    this.page = 0,
    this.limit = 10,
    List<Map<String, dynamic>>? dataList,
  }) : dataList = dataList ?? [];

  ImgUtilsHistoryState copyWith({
    bool? isLoading,
    bool? success,
    String? msg,
    bool? hasMore,
    int? page,
    int? limit,
    List<Map<String, dynamic>>? dataList,
  }) {
    return ImgUtilsHistoryState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      msg: msg ?? this.msg,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      dataList: dataList ?? this.dataList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
   isLoading,
   success,
   msg,
   hasMore,
   page,
   limit,
   dataList
  ];
}


class ImgUtilsHistoryBloc extends Cubit<ImgUtilsHistoryState> {
  ImgUtilsHistoryBloc() : super(ImgUtilsHistoryState());

  Future<void> loadInitialHistory() async {
    try {
      emit(state.copyWith(isLoading: true, page: 0));

      final data = await SqflDB.instance.getTableData(
        tableName: TableName.img_utils,
        limit: state.limit,
        offset: 0,
      );

      emit(state.copyWith(
        isLoading: false,
        success: true,
        dataList: data,
        hasMore: data.length == state.limit,
      ));
    } catch (e) {
      e.printResponse(title: "load init history exception");
      emit(state.copyWith(
        isLoading: false,
        success: false,
        msg: e.toString(),
      ));
    }
  }

  Future<void> loadMoreHistory() async {
    try {

      if (state.isLoading || !state.hasMore) return;

      emit(state.copyWith(isLoading: true));

      final nextPage = state.page + 1;
      final offset = nextPage * state.limit;

      final future = await Future.wait([
        SqflDB.instance.getTableData(
          tableName: TableName.img_utils,
          limit: state.limit,
          offset: offset,
        ),
        3.second.wait()
      ]);

      final data = (future[0] as List<Map<String, dynamic>>);


      emit(state.copyWith(
        isLoading: false,
        page: nextPage,
        dataList: [...state.dataList, ...data],
        hasMore: data.length == state.limit,
      ));
    } catch (e) {
      e.printResponse(title: "load more history exception");
      emit(state.copyWith(
        isLoading: false,
        msg: e.toString(),
      ));
    }
  }

  Future<void> removeValue({required int index}) async {
    try {

      final historyList = List<Map<String, dynamic>>.from(state.dataList);

      final future = await Future.wait([
        SqflDB.instance.deleteData(tableName: TableName.img_utils, id: historyList[index]["id"] ?? ""),
        if(await File(historyList[index]["video"] ?? "").exists()) File(historyList[index]["video"] ?? "").delete(recursive: true),
        3.second.wait()
      ]);

      if((future[0] as bool)) {

        historyList.removeAt(index);

        emit(state.copyWith(dataList: historyList));

      } else {

      }

    } catch(e) {
      e.printResponse(title: "remove history value exception");
    }
  }

  Future<void> addIndexValue({required DbModel dbModel}) async {
    try {

      emit(state.copyWith(dataList: [dbModel.toJson(), ...state.dataList]));

    } catch(e) {
      e.printResponse(title: "remove history value exception");
    }
  }
}
