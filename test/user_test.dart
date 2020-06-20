import 'dart:convert';
import 'package:climbing/models/user.dart';
import 'package:test/test.dart';

void main() {
  const String UUID = 'IBUUYU65viu*&kjlhbuKJHG';
  const String NAME = 'Александр Хоннолд';
  const String EMAIL = 'alex.honnold@gmail.com';
  const String PICTURE_ID = 'KGBiuygi*7)g87g-O*&go';

  test('Gym instance can be deserialized from json string', () {
    final User user = User.fromJson(json.decode('''{
      "uuid": "$UUID",
      "name": "$NAME",
      "email": "$EMAIL",
      "pictureId": "$PICTURE_ID"
    }'''));
    expect(user.token, UUID);
    expect(user.name, NAME);
    expect(user.email, EMAIL);
    expect(user.pictureId, PICTURE_ID);
  });
}
