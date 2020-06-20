import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/models/sign_in_with_apple_response.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/services/sign_in_service_abstract.dart';
import '../api/api.dart' as api;

class AppleSignInService implements SignInService {
  bool _available;

  @override
  Future<User> signIn() async {
    if (await isAvailable()) {
      final AuthorizationResult result =
          await AppleSignIn.performRequests(<AuthorizationRequest>[
        const AppleIdRequest(
            requestedScopes: <Scope>[Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final SignInWithAppleResponse signInWithAppleResponse =
              await api.appleSignIn(result.credential);
          if (signInWithAppleResponse == null ||
              signInWithAppleResponse.user == null) {
            throw Exception('Bad response from api.appleSignIn');
          }
          api.token = signInWithAppleResponse.user.token;
          return signInWithAppleResponse.user;
        case AuthorizationStatus.error:
          // TODO(Mikhail): handle authorization error
          break;
        case AuthorizationStatus.cancelled:
          // TODO(Mikhail): handle case when user cancelled
          break;
      }
    }
    return null;
  }

  @override
  Future<bool> isSignedIn(User user) async {
    if (await isAvailable()) {
      final CredentialState credentialState =
          await AppleSignIn.getCredentialState(user.appleIdCredentialUser);
      switch (credentialState.status) {
        case CredentialStatus.authorized:
          return true;
          break;
        case CredentialStatus.error:
          print(
              'getCredentialState returned an error: ${credentialState.error.localizedDescription}');
          break;
        case CredentialStatus.revoked:
          print('getCredentialState returned revoked');
          break;
        case CredentialStatus.notFound:
          print('getCredentialState returned not found');
          break;
        case CredentialStatus.transferred:
          print('getCredentialState returned not transferred');
          break;
      }
    }
    return false;
  }

  @override
  Future<bool> isAvailable() async {
    _available ??= await AppleSignIn.isAvailable();
    return _available;
  }

  @override
  void credentialsRevoked(Function callback) {
    AppleSignIn.onCredentialRevoked.listen((_) {
      callback();
    });
  }
}
