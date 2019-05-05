import 'package:climbing/classes/user.dart';

///
/// Encapsulates everything regarding user authorization
class Session {
  User _user;

  User get user => _user;

  bool get signedIn => _user != null ? true : false;

  signIn() {
    _user = User('', 'Александр Хоннолд', 'alex.honnold@gmail.com');
  }

  signOut() {
    _user = null;
  }

  register() {
    _user = User('', 'Александр Хоннолд', 'alex.honnold@gmail.com');
  }
}
