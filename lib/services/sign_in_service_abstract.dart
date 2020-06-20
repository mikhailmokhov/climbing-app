import 'package:climbing/models/user.dart';

abstract class SignInService{
  Future<User> signIn();
  Future<bool> isSignedIn(User user);
  Future<bool> isAvailable();
  void credentialsRevoked(Function callback);
}