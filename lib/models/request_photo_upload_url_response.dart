import 'package:lombok/lombok.dart';

@data
class RequestPhotoUploadUrlResponse {

  RequestPhotoUploadUrlResponse.fromJson(Map<String, dynamic> json)
      : fileId = json['fileId'] as String,
        url = json['url'] as String;

  String fileId;
  String url;
}
