import 'package:flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';

class FlushBar {
  static showDioError(DioError dioError, context) {
    Flushbar(
      title: "Request Error",
      message: dioError.message,
      duration: Duration(seconds: 3),
      borderRadius: 3,
      margin: EdgeInsets.all(8),
    )..show(context);
  }
}
