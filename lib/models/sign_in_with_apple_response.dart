import 'package:climbing/classes/user.dart';

class SignInWithAppleResponse {
  User user;
  bool newUser;

  SignInWithAppleResponse.fromJson(Map<String, dynamic> json)
      : this.user = new User.fromJson(json["user"]),
        this.newUser = json["newUser"];
}
