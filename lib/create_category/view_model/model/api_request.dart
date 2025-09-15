import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/typedef/typedef.dart';

abstract class ApiComponent {
  static const kFluxBearerToken = "a408f4dd-f557-4969-8889-dd9261c8d0fb";
  static const kGenerateImgApiUrl = "https://api.bfl.ai/v1/flux-kontext-pro";

  static Dio get dio => Dio();
}

class ApiRequest extends ApiComponent {

  static Future<ApiResponseRecord> generateImg({required String img, required String prompt}) async {

    try {

      final data = {
        "prompt": prompt,
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

        return (success: true, msg: "Image generate successfully!", value: response.data["polling_url"] ?? "");
      } else {
        throw response.handleRequestStatusCodeException().msg;
      }
    } catch (e) {
      e.printResponse(title: "generate img exception");
      return (success: false, msg: e.parseException().msg, value: "");
    }
  }

  static Future<ApiResponseRecord> getImgStatus({required String url}) async {
    try {
      url.printResponse(title: "img status url");

      final response = await ApiComponent.dio.get(
          url,
          options: Options(
              headers: {
                "accept": "application/json",
                "content-type": "application/json",
                "x-key": ApiComponent.kFluxBearerToken
              }
          )
      );

      (response.data as Object).printResponse(title: "img status response");

      if (response.statusCode == 200) {
        switch (response.data["status"] ?? "") {
          case "Ready":
            return (success: true, msg: "Image generated successfully!", value: response.data["result"]["sample"] ?? "");
          case "Pending":
            await 3.second.wait();
            return await getImgStatus(url: url); // ✅ recursion returns value
          case "Error":
          case "Failed":
          case "Request Moderated":
            return (success: false, msg: "Image generated unsuccessfully!", value: "");
          default:
            return (success: false, msg: "Something went wrong", value: "");
        }
      } else {
        return (success: false, msg: response.handleRequestStatusCodeException().msg, value: "");
      }
    } catch (e) {
      e.printResponse(title: 'get img status exception');
      return (success: false, msg: e.parseException().msg, value: "");
    }
  }
}