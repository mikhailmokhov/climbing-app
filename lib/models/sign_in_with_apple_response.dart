import 'package:climbing/models/user.dart';

class SignInWithAppleResponse {
  SignInWithAppleResponse.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json['user'] as Map<String, dynamic>),
        newUserFlag = json['newUserFlag'] as bool,
        token = json['token'] as String;

  User user;
  bool newUserFlag;
  String token;
}
