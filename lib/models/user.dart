import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/api/api.dart';
import 'package:climbing/enums/role.dart';
import 'package:climbing/models/user_authority.dart';
import 'package:google_sign_in/google_sign_in.dart';

///
/// Describes user
class User {
  User(
      this.token,
      this.googleId,
      this.name,
      this.email,
      this.nickname,
      this.pictureId,
      this.photoPath,
      this.appleIdCredentialUser,
      this.authorities,
      this.bookmarks);

  User.fromGoogleSignInAccount(GoogleSignInAccount googleSignInAccount)
      : googleId = googleSignInAccount.id,
        email = googleSignInAccount.email,
        name = googleSignInAccount.displayName,
        token = '',
        photoPath = googleSignInAccount.photoUrl;

  User.fromAppleIdCredentials(AppleIdCredential appleIdCredential) {
    token = '';
    email = appleIdCredential.email;
    nickname = '';
    name = appleIdCredential.fullName.givenName +
        ' ' +
        appleIdCredential.fullName.familyName;
  }

  User.fromJson(dynamic json)
      : token = json['token'] as String,
        googleId = json['googleId'] as String,
        name = json['name'] as String ?? '',
        email = json['email'] != null ? json['email'] as String : '',
        nickname = json['nickname'] != null ? json['nickname'] as String : '',
        pictureId =
            json['pictureId'] != null ? json['pictureId'] as String : '',
        photoPath =
            json['photoPath'] != null ? json['photoPath'] as String : '',
        appleIdCredentialUser = json['appleIdCredentialUser'] != null
            ? json['appleIdCredentialUser'] as String
            : '' {
    if (json['authorities'] is List)
      for (final dynamic authority in json['authorities'])
        if (authority is Map<String, dynamic>)
          authorities.add(UserAuthority.fromJson(authority));
    if (json['bookmarks'] is List)
      for (final dynamic homeGymId in json['bookmarks'])
        if (homeGymId is String) {
          bookmarks.add(homeGymId);
        }
  }

  String token;
  String googleId;
  String name = '';
  String email = '';
  String nickname = '';
  String pictureId = '';
  String photoPath = '';
  String appleIdCredentialUser;
  List<UserAuthority> authorities = <UserAuthority>[];
  Set<String> bookmarks = <String>{};

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> authoritiesMap = <Map<String, dynamic>>[];
    for (final UserAuthority authority in authorities)
      authoritiesMap.add(authority.toJson());
    return <String, dynamic>{
      'token': token,
      'googleId': googleId,
      'name': name,
      'nickname': nickname,
      'email': email,
      'pictureId': pictureId,
      'photoPath': photoPath,
      'appleIdCredentialUser': appleIdCredentialUser,
      'authorities': authoritiesMap,
      'bookmarks': bookmarks.toList()
    };
  }

  bool isAdmin() {
    for (final UserAuthority authority in authorities)
      if (authority.authority == Role.ROLE_ADMIN) {
        return true;
      }
    return false;
  }

  String getPictureUrl() {
    if (photoPath.isNotEmpty) {
      return CDN_PATH + photoPath;
    } else {
      return CDN_PATH + '/avatar/av0.jpg';
    }
  }
}
