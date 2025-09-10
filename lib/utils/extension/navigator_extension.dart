import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  Future<dynamic> push({required Widget widget}) async => await Navigator.push(
      this, MaterialPageRoute(builder: (context) => widget));

  Future<dynamic> pushReplacement({required Widget widget}) async =>
      await Navigator.pushReplacement(
          this, MaterialPageRoute(builder: (context) => widget));

  Future<dynamic> pushReplacementWithPopUntil({required Widget widget}) async {
    Navigator.popUntil(this, (route) => route.isFirst);
    return await Navigator.push(
        this, MaterialPageRoute(builder: (context) => widget));
  }

  void pop({dynamic result}) => Navigator.of(this).pop(result);
}
