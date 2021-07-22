part of 'package:climbing/api/api.dart';

Future<RequestPhotoUploadUrlResponse> routesGenerateUploadUrl(
    String gymId, String fileExtension) async {
  final Response<Map<String, String>> response = await _dio.get(
      '/routes/generateUploadUrl',
      queryParameters: <String, String>{
        'gymId': gymId,
        'fileExtension': fileExtension
      },
      options: _generateOptions());
  return RequestPhotoUploadUrlResponse.fromJson(response.data);
}
