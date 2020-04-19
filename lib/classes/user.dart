import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/authority.dart';
import 'package:climbing/classes/role.dart';
import 'package:google_sign_in/google_sign_in.dart';

///
/// Describes user
class User {
  String uuid;
  String googleId;
  String name = '';
  String email = '';
  String nickname = '';
  String pictureId = '';
  String photoUrl = '';
  String appleIdCredentialUser;
  List<Authority> authorities = List<Authority>();

  User(
      {this.googleId,
      this.uuid,
      this.nickname,
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

  User.fromAppleIdCredentials(AppleIdCredential appleIdCredential) {
    this.uuid = '';
    this.email = appleIdCredential.email;
    this.nickname = appleIdCredential.email;
    this.name = appleIdCredential.fullName.givenName +
        ' ' +
        appleIdCredential.fullName.familyName;
  }

  User.fromJson(Map<String, dynamic> json)
      : this.uuid = json['uuid'],
        this.googleId = json['uuigoogleIdd'],
        this.name = json['name'] != null ? json['name'] : '',
        this.email = json['email'] != null ? json['email'] : '',
        this.nickname = json['nickname'] != null ? json['nickname'] : '',
        this.pictureId = json['pictureId'] != null ? json['pictureId'] : '',
        this.photoUrl = json['photoUrl'] != null ? json['photoUrl'] : '',
        this.appleIdCredentialUser = json['appleIdCredentialUser'] != null
            ? json['appleIdCredentialUser']
            : '' {
    if (json['authorities'] is List)
      for (final authority in json['authorities'])
        this.authorities.add(Authority.fromJson(authority));
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> authoritiesMap = [];
    for (final Authority authority in authorities)
      authoritiesMap.add(authority.toJson());
    return {
      'uuid': this.uuid,
      'googleId': this.googleId,
      'name': this.name,
      'nickname': this.nickname,
      'email': this.email,
      'pictureId': this.pictureId,
      'photoUrl': this.photoUrl,
      'appleIdCredentialUser': this.appleIdCredentialUser,
      'authorities': authoritiesMap
    };
  }

  bool isAdmin() {
    for (final Authority authority in authorities)
      if (authority.authority == Role.ROLE_ADMIN) return true;
    return false;
  }

  String getPictureUrl() {
    if (photoUrl.isNotEmpty) {
      return photoUrl;
    } else {
      return 'http://mokhov.ca/honnold.png';
    }
  }
}
