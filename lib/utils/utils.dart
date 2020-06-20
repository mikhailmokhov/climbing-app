import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/ui/dialogs/sign_in_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  static void showSignInDialog(
      BuildContext context,
      Set<SignInProvider> signInProviderSet,
      void Function(SignInProvider) signIn) {
    showDialog<void>(
      context: context,
      builder: (BuildContext passedContext) => SignInDialog(
        signIn: (SignInProvider signInProvider) {
          signIn(signInProvider);
        },
        signInProviderSet: signInProviderSet,
      ),
    );
  }

  static String toMessage(dynamic e) {
    String errorText = '';
    if (e is Error || e is PlatformException) {
      errorText = e.toString();
    } else if (e is String) {
      errorText = e;
    } else if (e is DioError) {
      final DioError dioError = e;
      if (dioError.response != null &&
          dioError.response.data is Map<String, dynamic>) {
        final dynamic map = dioError.response.data;
        if (map.containsKey('status') != null)
          errorText += map['status'].toString() + ' ';
        if (map.containsKey('error') != null) {
          errorText += map['error']  + ': ' as String;
        }
        if (map.containsKey('message') != null) {
          errorText += map['message'] + ' ' as String;
        }
      } else {
        errorText = dioError.toString();
      }
    } else {
      errorText = 'Unknown Error';
    }
    throw e;
    return errorText.substring(0, 20);
  }

  static void showError(
      Flushbar<dynamic> flushbar, dynamic e, BuildContext context) {
    flushbar?.dismiss();
    flushbar = Flushbar<dynamic>(
      message: Utils.toMessage(e),
      backgroundColor: Colors.deepOrange,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    )..show(context);
  }
}
