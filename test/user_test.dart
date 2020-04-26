import 'dart:convert';
import 'package:climbing/classes/user.dart';
import 'package:test/test.dart';

void main() {
  const String UUID = 'IBUUYU65viu*&kjlhbuKJHG';
  const String NAME = 'Александр Хоннолд';
  const String EMAIL = 'alex.honnold@gmail.com';
  const String PICTURE_ID = 'KGBiuygi*7)g87g-O*&go';

  test("Gym instance can be created", () {
    User user = User(token: UUID, name: NAME, email: EMAIL);
    expect(user.token, UUID);
    expect(user.name, NAME);
    expect(user.email, EMAIL);
  });

  test("Gym instance can be deserialized from json string", () {
    User user = User.fromJson(json.decode('''{
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

  test("Gym instance can be serialized to json string", () {
    User user = new User(token: UUID, name: NAME, email: EMAIL);
    String jsonString = json.encode(user.toJson());
    expect(jsonString,
        '{"uuid":"$UUID","name":"$NAME","email":"$EMAIL","pictureId":"$PICTURE_ID"}');
  });
}
