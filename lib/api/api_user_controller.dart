part of 'package:climbing/api/api.dart';

Future<SignInWithAppleResponse> appleSignIn(
    AppleIdCredential appleIdCredential) async {
  final Response<Map<String, dynamic>> response = await _dio.post(
      '/user/login/apple',
      data: AppleIdCredentialConverter.toMap(appleIdCredential));
  final SignInWithAppleResponse responseObject =
  SignInWithAppleResponse.fromJson(response.data);
  return responseObject;
}

Future<Response<void>> logout() async {
  return _dio.get('/user/logout', options: _generateOptions());
}

Future<void> updateUser({String fullName, String nickname}) async {
  final Map<String, String> map = <String, String>{};
  if(fullName!=null){
    map['name'] = fullName;
  }
  if(fullName!=null){
    map['nickname'] = nickname;
  }
  await _dio.post<void>('/user',
      data: map, options: _generateOptions());
}

Future<User> getUser() async {
  final Response<Map<String, dynamic>> response =
  await _dio.get('/user', options: _generateOptions());
  return User.fromJson(response.data);
}

/// Saves gym to user's bookmarks. If a third party provider is used like Yelp
/// (in this case gym does not exit in the database), a new gym is created and
/// added to the database along with the Yelp id.
/// Returns internal id of the gym.
Future<String> addGymToBookmarks(GymId gymId) async {
  final Response<String> response = await _dio.post('/user/bookmarks',
      queryParameters: <String, dynamic>{
        'provider': EnumToString.convertToString(gymId.provider),
        'id': gymId.id
      },
      options: _generateOptions());
  if (response.data == null || response.data.isEmpty) {
    throw Exception('Returned gym id is empty');
  }
  return response.data;
}

Future<void> removeGymFromBookmarks(String internalGymId) async {
  final Response<void> response = await _dio.delete('/user/bookmarks',
      queryParameters: <String, String>{'gymId': internalGymId},
      options: _generateOptions());
  return response.data;
}

Future<String> updatePhotoUrl(String fileName) async {
  final Response<String> response = await _dio.get('/user/updatePhotoUrl',
      queryParameters: <String, String>{'fileName': fileName},
      options: _generateOptions());
  return response.data;
}

Future<String> validateFullName(String value) async {
  final Response<String> response = await _dio.get<String>(
      '/user/validateFullName',
      queryParameters: <String, String>{'value': value},
      options: _generateOptions());
  return response.data;
}

Future<String> validateNickname(String value) async {
  final Response<String> response = await _dio.get<String>(
      '/user/validateNickname',
      queryParameters: <String, String>{'value': value},
      options: _generateOptions());
  return response.data;
}

Future<RequestPhotoUploadUrlResponse> requestUploadPhotoUrl(
    String fileExtension) async {
  final Response<Map<String, dynamic>> response = await _dio.get(
      '/user/generatePresignedUploadUrl',
      queryParameters: <String, String>{'fileExtension': fileExtension},
      options: _generateOptions());
  return RequestPhotoUploadUrlResponse.fromJson(response.data);
}

