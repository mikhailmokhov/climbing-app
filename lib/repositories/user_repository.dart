import 'dart:convert';

import 'package:climbing/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A class that loads and persists user.
class UserRepository {
  UserRepository({@required this.storage});

  static const String STORAGE_KEY_USER = 'user';
  final FlutterSecureStorage storage;

  /// Loads user from local storage if user is saved there, otherwise returns null
  Future<User> loadUser() async {
    final String data = await storage.read(key: STORAGE_KEY_USER);
    if (data == null) {
      return null;
    }
    return User.fromJson(json.decode(data));
  }

  Future<void> saveUser(User user) async {
    await storage.write(
        key: STORAGE_KEY_USER, value: json.encode(user.toJson()));
  }

  Future<void> clearUser() async {
    await storage.delete(key: STORAGE_KEY_USER);
  }
}
