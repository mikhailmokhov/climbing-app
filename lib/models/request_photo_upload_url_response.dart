import 'package:lombok/lombok.dart';

@data
class RequestPhotoUploadUrlResponse {
  String fileId;
  String url;

  RequestPhotoUploadUrlResponse.fromJson(Map<String, dynamic> json)
      : this.fileId = json['fileId'],
        this.url = json['url'];
}
