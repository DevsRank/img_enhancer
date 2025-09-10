import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_enhancer_app/create_category/view_model/bloc/loading_btn/loading_btn_bloc.dart';
import 'package:image_enhancer_app/create_category/view_model/bloc/loading_view/loading_view_bloc.dart';
import 'package:image_enhancer_app/create_category/view_model/model/create_category_option.dart';
import 'package:image_enhancer_app/sub_category/view_model/model/sub_category_option.dart';
import 'package:image_enhancer_app/utils/enum/category_type.dart';
import 'package:image_enhancer_app/utils/enum/loading_state.dart';
import 'package:image_enhancer_app/utils/enum/loading_type.dart';
import 'package:image_enhancer_app/utils/enum/permission_type.dart';
import 'package:image_enhancer_app/utils/enum/sub_category_type.dart';
import 'package:image_enhancer_app/utils/enum/table_name.dart';
import 'package:image_enhancer_app/utils/typedef/typedef.dart';
import 'package:permission_handler/permission_handler.dart';



extension LoadingViewExtension on BuildContext {
  void showLoadingView({required LoadingType loadingType, String? title}) {
    read<LoadingViewBloc>().setLoading(loadingType: loadingType, title: title);
  }

  void stopLoadingView() {
    read<LoadingViewBloc>().stopLoading();
  }
}

extension DelayExtension on Duration {
  Future<void> wait() async => await Future.delayed(this);
}

extension TableHeaderIdentifierExtension on TableName {

  TableNameRecord option() {
    switch(this) {
   case TableName.img_utils:
     return (header: "CREATE TABLE IMG_UTILS(id INTEGER PRIMARY KEY, img TEXT, provide_img TEXT, prompt TEXT, first_attribute_index INTEGER, create_at TEXT)", name: "IMG_UTILS");
     case TableName.magic_remover:
     return (header: "CREATE TABLE MAGIC_REMOVER(id INTEGER PRIMARY KEY, img TEXT, provide_img TEXT, prompt TEXT, first_attribute_index INTEGER, create_at TEXT)", name: "MAGIC_REMOVER");
    case TableName.fun_preset:
     return (header: "CREATE TABLE FUN_PRESET(id INTEGER PRIMARY KEY, img TEXT, provide_img TEXT, prompt TEXT, first_attribute_index INTEGER, create_at TEXT)", name: "FUN_PRESET");
     default:
        return (header: "CREATE TABLE NONE(id INTEGER PRIMARY KEY)", name: "NONE");
    }
  }

}

extension SubCategoryTypeExtension on SubCategoryType {

  SubCategoryOptionRecord option() {
    switch(this) {
      case SubCategoryType.photo_enhancer:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.move_camera:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.relight:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.product_photo:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.zoom:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.colorize:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.bkg_remover:
        return (firstAttributeList: CreateCategoryOption.bkg_remover.expand((item) => item['sub_color_list'] as List<Map<String, dynamic>>).toList());
        case SubCategoryType.remove_object:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.remove_text:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.cartoonify:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.movie_poster:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.hair_cut:
        return (firstAttributeList: <Map<String, dynamic>>[]);
        case SubCategoryType.turn_into_avatar:
        return (firstAttributeList: CreateCategoryOption.turn_into_avatar);
        case SubCategoryType.body_builder:
        return (firstAttributeList: <Map<String, dynamic>>[]);
      default:
        return (firstAttributeList: <Map<String, dynamic>>[]);
    }
  }

  CategoryType getCategoryType() {
    switch(this) {
      case SubCategoryType.photo_enhancer:
      case SubCategoryType.move_camera:
      case SubCategoryType.relight:
      case SubCategoryType.product_photo:
      case SubCategoryType.zoom:
      case SubCategoryType.colorize:
        return CategoryType.img_utils;
      case SubCategoryType.bkg_remover:
      case SubCategoryType.remove_object:
      case SubCategoryType.remove_text:
        return CategoryType.magic_remover;
      case SubCategoryType.cartoonify:
      case SubCategoryType.movie_poster:
      case SubCategoryType.hair_cut:
      case SubCategoryType.turn_into_avatar:
      case SubCategoryType.body_builder:
        return CategoryType.fun_preset;
      default:
        return CategoryType.none;
    }
  }
}

extension CategoryTypeExtension on CategoryType {

  TableName tableName() {
    switch(this) {
      case CategoryType.img_utils:
        return TableName.img_utils;
        case CategoryType.magic_remover:
        return TableName.magic_remover;
        case CategoryType.fun_preset:
        return TableName.fun_preset;
      default:
        return TableName.none;
    }
  }

  CategoryOptionRecord option() {
    switch(this) {
      case CategoryType.img_utils:
        return (subCategoryList: SubCategoryOption.img_utils);
      case CategoryType.magic_remover:
        return (subCategoryList: SubCategoryOption.magic_remover);
      case CategoryType.fun_preset:
        return (subCategoryList: SubCategoryOption.fun_preset);
      default:
        return (subCategoryList: <Map<String, dynamic>>[]);
    }
  }
}

extension PermissionHandlerExtension on PermissionType {
  Future<bool> requestStoragePermission() async {
    switch(this) {
      case PermissionType.STORAGE:
        if (Platform.isAndroid) {
          int sdkInt = int.tryParse(RegExp(r'\d+').firstMatch(Platform.operatingSystemVersion)?.group(0) ?? '0') ?? 0;

          if (sdkInt >= 33) {
            // Android 13+ → use mediaImages for photos/images
            return await Permission.photos.request().isGranted;
          } else {
            // Android 12 and below
            return await Permission.storage.request().isGranted;
          }
        } else {

          return await Permission.photos.request().isGranted;
        }
      default:
        return false;
    }
  }
}

extension ActionStateTrackerExtension on BuildContext {
  bool isActionRunning({required LoadingState loadingState}) {
    if(read<BtnLoadingBloc>().state[loadingState] != null) {
      if(read<BtnLoadingBloc>().state[loadingState]!.isLoading) {

        return true;
      } else if(read<BtnLoadingBloc>().state[loadingState]!.progress != null) {

        return true;
      } else if(!read<BtnLoadingBloc>().state[loadingState]!.enable) {

        return true;
      } else {

        return false;
      }
    } else {

      return false;
    }
  }
}

extension RequestStatusCodeExceptionExtension on Response<dynamic> {
  ({String msg}) handleRequestStatusCodeException() {
    if (statusCode != null) {
      final statusCode = this.statusCode;
      final data = this.data;

      if (statusCode != null) {
        switch (statusCode) {
          case 400:
            return (msg: _parseErrorMessage(data) ?? "Bad request. Please check your input.");
          case 401:
            return (msg: _parseErrorMessage(data) ?? "Unauthorized. Please login again.");
          case 403:
            return (msg: _parseErrorMessage(data) ?? "Forbidden. You don't have permission.");
          case 404:
            return (msg: _parseErrorMessage(data) ?? "Resource not found.");
          case 408:
            return (msg: _parseErrorMessage(data) ?? "Request timeout.");
          case 409:
            return (msg: _parseErrorMessage(data) ?? "Conflict occurred.");
          case 422:
            return (msg: _parseErrorMessage(data) ?? "Validation error. Please check your input.");
          case 429:
            return (msg: _parseErrorMessage(data) ?? "Too many requests. Please try again later.");
          case 500:
            return (msg: _parseErrorMessage(data) ?? "Internal server error. Please try again later.");
          case 502:
            return (msg: _parseErrorMessage(data) ?? "Bad gateway.");
          case 503:
            return (msg: _parseErrorMessage(data) ?? "Service unavailable. Please try again later.");
          case 504:
            return (msg: _parseErrorMessage(data) ?? "Gateway timeout.");
          default:
            return (msg: _parseErrorMessage(data) ?? "Request failed with status code $statusCode");
        }
      }
    }
    return (msg: "Request failed with no response.");
  }
}

extension ExceptionExtension on Object {
  ({String msg}) parseException() {
    if (this is SocketException) {
      return (msg: "No internet connection. Please check your network settings.");
    } else if (this is TimeoutException) {
      return (msg: "Request timed out. Please try again.");
    } else if (this is DioException) {
      final dioError = this as DioException;
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return (msg: "Request timed out. Please try again.");
        case DioExceptionType.badCertificate:
          return (msg: "Security error: Invalid certificate.");
        case DioExceptionType.badResponse:
          return _handleDioBadResponse(dioError);
        case DioExceptionType.cancel:
          return (msg: "Request was cancelled.");
        case DioExceptionType.connectionError:
          return (msg: "Connection error. Please check your network.");
        case DioExceptionType.unknown:
          return (msg: "An unexpected error occurred.");
      }
    } else if (this is FormatException) {
      return (msg: "Data format error. Please try again with valid data.");
    } else if (this is HttpException) {
      return (msg: "HTTP request failed.");
    } else if (this is RangeError) {
      return (msg: "Invalid range error.");
    } else if (this is StateError) {
      return (msg: "Invalid state encountered.");
    } else if (this is ArgumentError) {
      return (msg: "Invalid argument provided.");
    } else if (this is NoSuchMethodError) {
      return (msg: "Method not found.");
    } else if (this is UnsupportedError) {
      return (msg: "Unsupported operation.");
    } else if (this is Exception) {
      return (msg: "An exception occurred: ${toString()}");
    } else {
      return (msg: toString());
    }
  }

  ({String msg}) _handleDioBadResponse(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      if (statusCode != null) {
        switch (statusCode) {
          case 400:
            return (msg: _parseErrorMessage(data) ?? "Bad request. Please check your input.");
          case 401:
            return (msg: _parseErrorMessage(data) ?? "Unauthorized. Please login again.");
          case 403:
            return (msg: _parseErrorMessage(data) ?? "Forbidden. You don't have permission.");
          case 404:
            return (msg: _parseErrorMessage(data) ?? "Resource not found.");
          case 408:
            return (msg: _parseErrorMessage(data) ?? "Request timeout.");
          case 409:
            return (msg: _parseErrorMessage(data) ?? "Conflict occurred.");
          case 422:
            return (msg: _parseErrorMessage(data) ?? "Validation error. Please check your input.");
          case 429:
            return (msg: _parseErrorMessage(data) ?? "Too many requests. Please try again later.");
          case 500:
            return (msg: _parseErrorMessage(data) ?? "Internal server error. Please try again later.");
          case 502:
            return (msg: _parseErrorMessage(data) ?? "Bad gateway.");
          case 503:
            return (msg: _parseErrorMessage(data) ?? "Service unavailable. Please try again later.");
          case 504:
            return (msg: _parseErrorMessage(data) ?? "Gateway timeout.");
          default:
            return (msg: _parseErrorMessage(data) ?? "Request failed with status code $statusCode");
        }
      }
    }
    return (msg: "Request failed with no response.");
  }

  String? _parseErrorMessage(dynamic data) {
    try {
      if (data is String) {
        return data;
      } else if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? data['msg'] ?? null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

extension DurationExtension on int {
  Duration get second => Duration(seconds: this);
  Duration get millisecond => Duration(milliseconds: this);
}

extension MediaQueryExtension on BuildContext {

  double get deviceWidth => MediaQuery.of(this).size.width;
  double get deviceHeight => MediaQuery.of(this).size.height;

  EdgeInsets get padding => MediaQuery.of(this).padding;

  static const double baseWidth = 360;
  static const double baseHeight = 800;

  double width(double width) => (width / baseWidth) * (MediaQuery.of(this).orientation == Orientation.portrait
  ? MediaQuery.of(this).size.width : MediaQuery.of(this).size.height);

  double height(double height) => (height / baseHeight) * (MediaQuery.of(this).orientation == Orientation.portrait
      ? MediaQuery.of(this).size.height : MediaQuery.of(this).size.width);

  double fontSize(double figmaFontSize) => width(figmaFontSize); // or use average of w+h if you want smarter scaling

}

extension BorderRadiusExtension on num {
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());
  BorderRadius get topRightBorderRadius => BorderRadius.only(topRight: Radius.circular(toDouble()));
  BorderRadius get topLeftBorderRadius => BorderRadius.only(topLeft: Radius.circular(toDouble()));
  BorderRadius get bottomRightBorderRadius => BorderRadius.only(bottomRight: Radius.circular(toDouble()));
  BorderRadius get bottomLeftBorderRadius => BorderRadius.only(bottomLeft: Radius.circular(toDouble()));
  Radius get radius => Radius.circular(toDouble());
}

extension EdgeInsetsExtension on num {
  EdgeInsets get rightEdgeInsets => EdgeInsets.only(right: toDouble());
  EdgeInsets get leftEdgeInsets => EdgeInsets.only(left: toDouble());
  EdgeInsets get topEdgeInsets => EdgeInsets.only(top: toDouble());
  EdgeInsets get bottomEdgeInsets => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get allEdgeInsets => EdgeInsets.all(toDouble());
  EdgeInsets get horizontalEdgeInsets => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get verticalEdgeInsets => EdgeInsets.symmetric(vertical: toDouble());
}

extension LoadingBtnExtension on BuildContext {

  void setBtnLoading({required LoadingState loadingState, double? progress, bool? blockUI}) async {
    if(FocusScope.of(this).hasPrimaryFocus && FocusScope.of(this).hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      "unfocused success".printResponse(title: "Focus scope");
    }
    read<BtnLoadingBloc>().startLoading(loadingState: loadingState, progress: progress, blockUI: blockUI);
  }

  void setBtnEnable({required LoadingState loadingState, required bool enable}) {
    if(FocusScope.of(this).hasPrimaryFocus && FocusScope.of(this).hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      "unfocused success".printResponse(title: "Focus scope");
    }
    read<BtnLoadingBloc>().enable(loadingState: loadingState, enable: enable);
  }

  void stopBtnLoading({required LoadingState loadingState}) {
    if(FocusScope.of(this).hasPrimaryFocus && FocusScope.of(this).hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      "unfocused success".printResponse(title: "Focus scope");
    }
    read<BtnLoadingBloc>().stopLoading(loadingState: loadingState);
  }
}

extension ResponseExtension on Object {
  void printResponse({required String title}) {
    if(kDebugMode) log("$title:\n${(this).toString()}");
  }
}

