import 'package:climbing/classes/user_class.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class SignInWithApple {
  static final Future<bool> isAvailable = AppleSignIn.isAvailable();
  static final onCredentialRevoked = AppleSignIn.onCredentialRevoked;

  static Future<User> signIn() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        FlutterSecureStorage()
            .write(key: "appleUserId", value: result.credential.user);
        break;

      case AuthorizationStatus.error:
        //TODO: handle authorization error
        break;

      case AuthorizationStatus.cancelled:
        //TODO: handle case when user cancelled
        break;
    }

    return User.fromAppleIdCredentials(result.credential);
  }
}
