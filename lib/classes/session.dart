import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:google_sign_in/google_sign_in.dart';

///
/// Encapsulates everything regarding user authorization
class Session {
  User _user;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User get user => _user;

  Future<User> isSignedIn() async {
    if (await googleSignIn.isSignedIn()) {
      _user = User.fromGoogleSignInAccount(await googleSignIn.signIn());
    }
    return _user;
  }

  Future<User> signInGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null)
      _user = User.fromGoogleSignInAccount(googleSignInAccount);
    return _user;
  }

  Future<User> signInApple() async {
    final AuthorizationResult authorizationResult = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    if (authorizationResult != null && authorizationResult.status == AuthorizationStatus.authorized) {
      _user = User.fromAppleAuthorizationResult(authorizationResult);
    }
    return _user;
  }

  signOut() async {
    await googleSignIn.signOut();
    _user = null;
    return _user;
  }

  register() {
    _user = User(
        username: 'honnold',
        name: 'Александр Хоннолд',
        email: 'alex.honnold@gmail.com');
  }
}
