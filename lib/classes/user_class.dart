import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

///
/// Describes user
class User {
  String uuid;
  String googleId;
  String name = '';
  String email = '';
  String username = '';
  String pictureId = '';
  String photoUrl = '';

  User({this.googleId,
    this.uuid,
    this.username,
    this.name,
    this.email,
    this.pictureId,
    this.photoUrl});

  User.fromGoogleSignInAccount(GoogleSignInAccount googleSignInAccount)
      : this.googleId = googleSignInAccount.id,
        this.email = googleSignInAccount.email,
        this.name = googleSignInAccount.displayName,
        this.uuid = '',
        this.photoUrl = googleSignInAccount.photoUrl;

  User.fromAppleIdCredentials(AppleIdCredential appleIdCredential)
  {
    this.uuid = '';
    this.email = appleIdCredential.email;
    this.username = appleIdCredential.email;
    this.name = appleIdCredential.fullName.givenName +
        ' ' +
        appleIdCredential.fullName.familyName;
  }

  User.fromJson(Map<String, dynamic> json)
      : this.uuid = json["uuid"],
        this.googleId = json["uuigoogleIdd"],
        this.name = json["name"],
        this.email = json["email"],
        this.username = json["username"],
        this.pictureId = json["pictureId"],
        this.photoUrl = json["photoUrl"];

  Map<String, dynamic> toJson() {
    return {
      'uuid': this.uuid,
      'googleId': this.googleId,
      'name': this.name,
      'username': this.username,
      'email': this.email,
      'pictureId': this.pictureId,
      'photoUrl': this.photoUrl
    };
  }

  String getPictureUrl() {
    if (photoUrl.isNotEmpty) {
      return photoUrl;
    } else {
      return 'http://mokhov.ca/honnold.png';
    }
  }
}
