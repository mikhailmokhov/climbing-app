import 'package:flutter/material.dart';

ThemeData darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    fontFamily: 'RobotooGoogle',
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }));

ThemeData lightThemeData = ThemeData(
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.redAccent),
    primarySwatch: Colors.teal,
    fontFamily: 'RobotooGoogle',
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }));
