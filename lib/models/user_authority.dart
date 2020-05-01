
import 'package:climbing/enums/role.dart';
import 'package:enum_to_string/enum_to_string.dart';

class UserAuthority {
  Role authority;

  Map<String, dynamic> toJson() {
    return {'authority': EnumToString.parse(this.authority)};
  }

  UserAuthority.fromJson(Map<String, dynamic> json) {
    assert(json.containsKey('authority'));
    assert(json['authority'] != null);
    authority = EnumToString.fromString(Role.values, json['authority']);
  }
}
