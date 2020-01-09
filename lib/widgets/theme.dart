import 'package:flutter/material.dart';

ThemeData darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }));

ThemeData lightThemeData = ThemeData(
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.redAccent),
    primarySwatch: Colors.teal,
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }));
