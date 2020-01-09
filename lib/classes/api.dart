import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/gyms_response.dart';
import 'package:climbing/classes/my_location.dart';
import 'package:climbing/sign_in/apple/apple_id_credential_converter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api {
  static final Dio _dio = Dio()
    ..options.baseUrl = "https://api.routesetter.app"
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    ));

  static Future<Response> appleSignIn(AppleIdCredential appleIdCredential) async {
    return _dio.post("/apple",
        data: AppleIdCredentialConverter.toMap(appleIdCredential));
  }

  static Future<Response> logout() async {
    return _dio.get("/logout");
  }

  static Future<GymsResponse> gyms(Coordinates coordinates) async {
    final Response response = await _dio.get("/gyms", queryParameters: coordinates.toMap());
    return GymsResponse.fromResponse(response.data);
  }

  static _checkInternetConnection() async {
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.mobile || connectivityResult != ConnectivityResult.wifi){
      throw "No Internet Connection";
    }
  }
}
