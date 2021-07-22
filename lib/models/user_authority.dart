import 'package:climbing/enums/role.dart';
import 'package:enum_to_string/enum_to_string.dart';

class UserAuthority {
  UserAuthority.fromJson(Map<String, dynamic> json)
      : assert(json.containsKey('authority')),
        assert(json['authority'] != null) {
    authority =
        EnumToString.fromString(Role.values, json['authority'] as String);
  }

  Role authority;

  Map<String, dynamic> toJson() {
    return <String, String>{'authority': EnumToString.parse(authority)};
  }
}
