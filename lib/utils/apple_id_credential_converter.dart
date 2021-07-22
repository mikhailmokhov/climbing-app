import 'dart:convert';

import 'package:apple_sign_in/apple_id_credential.dart';

class AppleIdCredentialConverter {
  static Map<String, dynamic> toMap(AppleIdCredential appleIdCredential) =>
      <String, dynamic>{
        'identityToken': String.fromCharCodes(appleIdCredential.identityToken),
        'authorizationCode':
            String.fromCharCodes(appleIdCredential.authorizationCode),
        'user': appleIdCredential.user,
        'fullName': <String, String>{
          'namePrefix': appleIdCredential.fullName.namePrefix,
          'givenName': appleIdCredential.fullName.givenName,
          'middleName': appleIdCredential.fullName.middleName,
          'familyName': appleIdCredential.fullName.familyName,
          'nameSuffix': appleIdCredential.fullName.nameSuffix,
          'nickname': appleIdCredential.fullName.nickname,
        },
        'email': appleIdCredential.email,
      };

  static String toJsonString(AppleIdCredential appleIdCredential) =>
      json.encode(toMap(appleIdCredential));
}
