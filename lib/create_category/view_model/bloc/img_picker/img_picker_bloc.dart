import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_enhancer_app/main.dart';
import 'package:image_enhancer_app/utils/enum/img_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/snackbar_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as path;

class ImgPickerBloc extends Cubit<ImgPickerState> {
  ImgPickerBloc() : super(ImgPickerState());

  Future<void> pickImg({required ImageSource imgSource}) async {
    try {
      emit(state.copyWith(loading: true));

      final picker = ImagePicker();
      final XFile? imgFile = await picker.pickImage(source: imgSource);
      if (imgFile == null) return emit(state.copyWith(loading: false));

      final originalFile = File(imgFile.path);
      final bytes = await originalFile.readAsBytes();
      final mb = bytes.length / (1024 * 1024);
      mb.printResponse(title: "original size in MB");

      // Decode image to check dimensions
      final decodedImage = await decodeImageFromList(bytes);
      int width = decodedImage.width;
      int height = decodedImage.height;

      const int minSize = 360;
      const int maxSize = 2000;

      // If image is smaller than min size → reject
      if (width < minSize || height < minSize) {
        emit(state.copyWith(loading: false));
        materialAppKey.showSnackBar(msg: "Image must be at least ${minSize}px in both width and height.");
        return;
      }

      // If image is larger than max size → scale it down proportionally
      if (width > maxSize || height > maxSize) {
        double scaleFactor = (width > height)
            ? maxSize / width
            : maxSize / height;
        width = (width * scaleFactor).round();
        height = (height * scaleFactor).round();

        "Resizing to ${width}x$height".printResponse(title: "Image resize");
      }

      final dir = await pp.getTemporaryDirectory();
      final targetPath = '${dir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';

// Compress & resize
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        quality: 80,
        minWidth: width,
        minHeight: height,
      );


      if (compressedFile == null) {
        emit(state.copyWith(loading: false));
        return;
      }

      final newBytes = await compressedFile.readAsBytes();
      final newMb = newBytes.length / (1024 * 1024);
      newMb.printResponse(title: "compressed size in MB");

      emit(state.copyWith(loading: false, img: compressedFile.path, imgType: ImgType.file));
    } catch (e) {
      e.printResponse(title: "pick img exception");
      emit(state.copyWith(loading: false));
    }
  }

  void setCstmImg({required String img, required ImgType imgType}) {
    emit(state.copyWith(img: img, imgType: imgType));
  }

  void clearState() => emit(state.copyWith(loading: false, clearImg: true, imgType: ImgType.none));
}

class ImgPickerState {
  final bool loading;
  final String? img;
  final ImgType imgType;

  ImgPickerState({
    this.loading = false,
    this.img,
    this.imgType = ImgType.none
  });

  ImgPickerState copyWith({bool? loading, String? img, bool? clearImg, ImgType? imgType}) {
    return ImgPickerState(
      loading: loading ?? this.loading,
      img: clearImg == true ? null : img ?? this.img,
      imgType: imgType ??  this.imgType
    );
  }
}
