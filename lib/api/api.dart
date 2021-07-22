library api;

import 'dart:async';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/models/coordinates.dart';
import 'package:climbing/models/gym.dart';
import 'package:climbing/models/gym_id.dart';
import 'package:climbing/models/request_photo_upload_url_response.dart';
import 'package:climbing/models/sign_in_with_apple_response.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/utils/apple_id_credential_converter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'api_gym_controller.dart';
part 'api_route_controller.dart';
part 'api_spaces.dart';
part 'api_user_controller.dart';

String token;

const String ROOT_PATH = '/api/v1';
const String CDN_PATH = 'https://cdn.routesetter.app';

final Dio _dio = Dio()
  ..options.baseUrl = foundation.kReleaseMode
      ? 'https://routesetter.app' + ROOT_PATH
      : 'http://localhost:8080' + ROOT_PATH
  //!!! May require to comment out next line
  ..httpClientAdapter = Http2Adapter(ConnectionManager())
  //!!!
  ..options.connectTimeout = 5000
  ..options.receiveTimeout = 5000
  ..interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    compact: true,
  ));

Options _generateOptions() {
  final Options options = Options();
  if (token != null)
    options.headers
        .addAll(<String, String>{'Authorization': 'Bearer ' + token});
  return options;
}

String _resolveContentType(File file) {
  String mimeType = mime(file.path);
  mimeType ??= 'text/plain; charset=UTF-8';
  return mimeType;
}
