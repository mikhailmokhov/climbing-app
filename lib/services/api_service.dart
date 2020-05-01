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
import 'package:enum_to_string/enum_to_string.dart';

class ApiService {
  static String token;

  static final Dio _dio = Dio()
    ..options.baseUrl = Foundation.kReleaseMode
        ? "https://api.routesetter.app"
        : "http://localhost:8080"
    ..options.connectTimeout = 60000
    ..options.receiveTimeout = 60000
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    ));

  static Options generateOptions() {
    Options options = Options();
    if (token != null)
      options.headers.addAll({"Authorization": "Bearer " + token});
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

  static Future<GymsResponse> getGyms(Coordinates coordinates) async {
    final Response response =
        await _dio.get("/gyms", queryParameters: coordinates.toMap());
    return GymsResponse.fromResponse(response.data);
  }

  static Future<void> updateUser(User user) async {
    await _dio.post("/user", data: user.toJson(), options: generateOptions());
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

  static uploadFile(String url, File file) async {
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

  static Future<String> validateFullName(String value) async {
    Response response = await _dio.get("/user/validateFullName",
        queryParameters: {"value": value}, options: generateOptions());
    return response.data;
  }

  static Future<String> validateNickname(String value) async {
    Response response = await _dio.get("/user/validateNickname",
        queryParameters: {"value": value}, options: generateOptions());
    return response.data;
  }

  static Future<void> addHomeGym(Gym gym) async {
    await _dio.post("/user/gyms",
        queryParameters: {"gymId": gym.id}, options: generateOptions());
    return;
  }

  static Future<void> setVisibility(Gym gym, bool visibility) async {
    String idProvider;
    String id;
    if (gym.id != null && gym.id.isNotEmpty) {
      idProvider = EnumToString.parse(GymsProvider.INTERNAL);
      id = gym.id;
    } else if (gym.yelpId != null && gym.yelpId.isNotEmpty) {
      idProvider = EnumToString.parse(GymsProvider.YELP);
      id = gym.yelpId;
    } else if (gym.googleId != null && gym.googleId.isNotEmpty) {
      idProvider = EnumToString.parse(GymsProvider.GOOGLE);
      id = gym.googleId;
    } else {
      throw "setVisibility error: all the gym ids are null";
    }
    await _dio.patch("/gyms/" + id,
        queryParameters: {"provider": idProvider, "visibility": visibility},
        options: generateOptions());
  }

  static Future<void> purgeYelpCacheForCoordinates(
      double latitude, double longitude) async {
    await _dio.delete("/gyms/cache/yelp",
        queryParameters: {"latitude": latitude, "longitude": longitude},
        options: generateOptions());
  }

  static Future<void> purgeYelpCache() async {
    await _dio.delete("/gyms/cache/yelp", options: generateOptions());
  }

//  static _checkInternetConnection() async {
//    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
//    if(connectivityResult != ConnectivityResult.mobile || connectivityResult != ConnectivityResult.wifi){
//      throw "No Internet Connection";
//    }
//  }
}
