import 'dart:async';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/gym_class.dart';
import 'package:climbing/classes/gyms_response.dart';
import 'package:climbing/classes/my_location.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/models/request_photo_upload_url_response.dart';
import 'package:climbing/models/sign_in_with_apple_response.dart';
import 'package:climbing/sign_in/apple/apple_id_credential_converter.dart';
import 'package:mime_type/mime_type.dart';

//import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:http/http.dart' as http;

class ApiService {
  static String uuid;

  static final Dio _dio = Dio()
    ..options.baseUrl = Foundation.kReleaseMode
        ? "https://api.routesetter.app"
        : "http://10.0.1.11:8080"
    ..options.connectTimeout = 10000
    ..options.receiveTimeout = 10000
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    ));

  static Options generateOptions() {
    Options options = Options();
    if (uuid != null)
      options.headers.addAll({"Authorization": "Bearer " + uuid});
    return options;
  }

  static Future<SignInWithAppleResponse> appleSignIn(
      AppleIdCredential appleIdCredential) async {
    Response response = await _dio.post("/user/login/apple",
        data: AppleIdCredentialConverter.toMap(appleIdCredential));
    SignInWithAppleResponse responseObject =
        SignInWithAppleResponse.fromJson(response.data);
    return responseObject;
  }

  static Future<Response> logout() async {
    return _dio.get("/user/logout", options: generateOptions());
  }

  static Future<GymsResponse> gyms(Coordinates coordinates) async {
    final Response response =
        await _dio.get("/gyms", queryParameters: coordinates.toMap());
    return GymsResponse.fromResponse(response.data);
  }

  static Future<bool> updateUser(User user) async {
    Response response = await _dio.post("/user",
        data: user.toJson(), options: generateOptions());
    return response.data;
  }

  static Future<User> getUser() async {
    Response response = await _dio.get("/user", options: generateOptions());
    return new User.fromJson(response.data);
  }

  static Future<RequestPhotoUploadUrlResponse> requestUploadPhotoUrl(
      String fileExtension) async {
    Response response = await _dio.get("/user/requestUploadPhotoUrl",
        queryParameters: {"fileExtension": fileExtension},
        options: generateOptions());
    return RequestPhotoUploadUrlResponse.fromJson(response.data);
  }

  static Future<String> updatePhotoUrl(String fileName) async {
    Response response = await _dio.get("/user/updatePhotoUrl",
        queryParameters: {"fileName": fileName}, options: generateOptions());
    return response.data;
  }

  static Future<void> uploadFile(String url, File file) async {
    assert(url.isNotEmpty && file != null && file.existsSync());
    await http.put(url,
        body: file.readAsBytesSync(),
        headers: {"Content-Type": resolveContentType(file)});
  }

  static String resolveContentType(File file) {
    String mimeType = mime(file.path);
    if (mimeType == null) mimeType = 'text/plain; charset=UTF-8';
    return mimeType;
  }

  static Future<void> addHomeGym(Gym gym) async {
    await _dio.post("/user/gyms", queryParameters: {"gymId": gym.id}, options: generateOptions());
    return;
  }

  static Future<void> markAsNotAGym(Gym gym) async {
    await _dio.patch("/user/gyms/" + gym.id, queryParameters: {"notAGym": true}, options: generateOptions());
  }

//  static _checkInternetConnection() async {
//    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
//    if(connectivityResult != ConnectivityResult.mobile || connectivityResult != ConnectivityResult.wifi){
//      throw "No Internet Connection";
//    }
//  }
}