import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/sign_in_with_apple.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:google_sign_in/google_sign_in.dart';

///
/// Encapsulates everything regarding user authorization
class Session {
  User _user;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'profile',
  ]);

  listen() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {});
    _googleSignIn.signInSilently();
  }

  User get user => _user;

  Future<User> isSignedIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signInSilently();
    if (googleSignInAccount != null) {
      _user = User.fromGoogleSignInAccount(await _googleSignIn.signIn());
    }
    return _user;
  }

  Future<User> signInGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount != null)
      _user = User.fromGoogleSignInAccount(googleSignInAccount);
    return _user;
  }

  signOut() async {
    //await googleSignIn.signOut();
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

enum SignWithType { Google, Apple }
