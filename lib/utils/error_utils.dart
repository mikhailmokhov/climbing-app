import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorUtils {
  static String toMessage(dynamic e) {
    String errorText = "";
    if (e is Error || e is PlatformException) {
      errorText = e.toString();
    } else if (e is String) {
      errorText = e;
    } else if (e is DioError) {
      DioError dioError = e;
      if (dioError.response != null &&
          dioError.response.data is Map<String, dynamic>) {
        Map<String, dynamic> map = dioError.response.data;
        if (map.containsKey("status"))
          errorText += map["status"].toString() + " ";
        if (map.containsKey("error")) errorText += map["error"] + ": ";
        if (map.containsKey("message")) errorText += map["message"] + " ";
      } else {
        errorText = dioError.toString();
      }
    } else {
      errorText = "Unknown Error";
    }
    return errorText;
  }

  static void showError(Flushbar flushbar, dynamic e, BuildContext context) {
    flushbar?.dismiss();
    flushbar = Flushbar(
      message: ErrorUtils.toMessage(e),
      backgroundColor: Colors.deepOrange,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    )..show(context);
  }
}
