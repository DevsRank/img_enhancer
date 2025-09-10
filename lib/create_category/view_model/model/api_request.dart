import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/typedef/typedef.dart';

abstract class ApiComponent {
  // for production
  static const kFluxBearerToken = "a408f4dd-f557-4969-8889-dd9261c8d0fb";
  // for debug
  // static const kFluxBearerToken = "a408f4dd-f557-4969-8889-dd9261c8d0fb";
  static const kGenerateImgApiUrl = "https://api.bfl.ai/v1/flux-kontext-pro";
  static const kGenerateImgResultApiUrl = "https://api.us1.bfl.ai/v1/get_result";

  static Dio get dio => Dio();
}

class ApiRequest extends ApiComponent {

  static Future<ApiResponseRecord> generateImg({required String img}) async {

    bool success = false;
    String msg = "";
    String id = "";

    try {

      final data = {
        "prompt":
        "Remove the background of the input image and replace it with promptBackground while keeping the main object/person intact. Keep the subject cleanly cut out, maintain natural proportions and realistic appearance.",
        "input_image": base64Encode(await File(img).readAsBytes()),
        "output_format": "png",
        "strength": 0.8,
        "width": 1024,
        "height": 1024,
      };

      data.printResponse(title: "generate img");

      final response = await ApiComponent.dio.post(
        ApiComponent.kGenerateImgApiUrl,
        options: Options(
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'x-key': ApiComponent.kFluxBearerToken,
            }
        ),
        data: jsonEncode(data),
      );

      (response.data as Object).printResponse(title: "generate img response");

      if (response.statusCode == 200) {
        success = true;
        msg = "Image generate successfully!";
        id = response.data["id"] ?? "";
      } else {
        success = false;
        msg = response.handleRequestStatusCodeException().msg;
        id = "";
      }

    } catch (e) {
      success = false;
      msg = e.parseException().msg;
      id = "";
      e.printResponse(title: "generate img exception");
    } finally {
      return (success: success, msg: msg, value: id);
  }
  }

  static Future<ApiResponseRecord> getImgStatus({required String id}) async {

    bool success = false;
    String msg = "";
    String img = "";

    try {

      id.printResponse(title: "img status id");

      final response = await ApiComponent.dio.get(
          "${ApiComponent.kGenerateImgResultApiUrl}?id=$id",
      options: Options(
        headers: {
          "accept": "application/json",
          "content-type": "application/json",
          "x-key": ApiComponent.kFluxBearerToken
        }
      )
      );

      (response.data as Object).printResponse(title: "img status response");

      if(response.statusCode == 200) {
        switch(response.data["status"] ?? "") {
          case "Ready":
            success = true;
            msg = "Image generated successfully!";
            img = response.data["result"]["sample"] ?? "";
            break;
          case "Error":
          case "Failed":
          success = false;
          msg = "Image generated unsuccessfully!";
          img = "";
            break;
          default:
            success = false;
            msg = "Something went wrong";
            img = "";
        }
      } else {
        success = false;
        msg = response.handleRequestStatusCodeException().msg;
        img = "";
      }

    } catch (e) {
      success = false;
      msg = e.parseException().msg;
      img = "";
      e.printResponse(title: 'get img status exception');
    } finally {
      return (success: success, msg: msg, value: img);
    }
  }
}