import 'package:climbing/models/user.dart';

class SignInWithAppleResponse {
  User user;
  bool newUserFlag;
  String token;

  SignInWithAppleResponse.fromJson(Map<String, dynamic> json)
      : this.user = new User.fromJson(json["user"]),
        this.newUserFlag = json["newUserFlag"],
        this.token = json["token"];
}
