import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/models/user_authority.dart';
import 'package:climbing/enums/role.dart';
import 'package:google_sign_in/google_sign_in.dart';

///
/// Describes user
class User {
  String token;
  String googleId;
  String name = '';
  String email = '';
  String nickname = '';
  String pictureId = '';
  String photoUrl = '';
  String appleIdCredentialUser;
  List<UserAuthority> authorities = List<UserAuthority>();
  List<String> homeGymIds= List<String>();

  User(
      {this.googleId,
      this.token,
      this.nickname,
      this.name,
      this.email,
      this.pictureId,
      this.photoUrl});

  User.fromGoogleSignInAccount(GoogleSignInAccount googleSignInAccount)
      : this.googleId = googleSignInAccount.id,
        this.email = googleSignInAccount.email,
        this.name = googleSignInAccount.displayName,
        this.token = '',
        this.photoUrl = googleSignInAccount.photoUrl;

  User.fromAppleIdCredentials(AppleIdCredential appleIdCredential) {
    this.token = '';
    this.email = appleIdCredential.email;
    this.nickname = '';
    this.name = appleIdCredential.fullName.givenName +
        ' ' +
        appleIdCredential.fullName.familyName;
  }

  User.fromJson(Map<String, dynamic> json)
      : this.token = json['token'],
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
        this.authorities.add(UserAuthority.fromJson(authority));
    if (json['homeGymIds'] is List)
      for (final homeGymId in json['homeGymIds'])
        this.homeGymIds.add(homeGymId);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> authoritiesMap = [];
    for (final UserAuthority authority in authorities)
      authoritiesMap.add(authority.toJson());
    return {
      'token': this.token,
      'googleId': this.googleId,
      'name': this.name,
      'nickname': this.nickname,
      'email': this.email,
      'pictureId': this.pictureId,
      'photoUrl': this.photoUrl,
      'appleIdCredentialUser': this.appleIdCredentialUser,
      'authorities': authoritiesMap,
      'homeGymIds': homeGymIds
    };
  }

  bool isAdmin() {
    for (final UserAuthority authority in authorities)
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
