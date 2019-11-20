import 'package:climbing/classes/session.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:climbing/widgets/gyms_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vibrate/vibrate.dart';



void main() => runApp(MyApp());

bool canVibrate = false;

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Session session;
  User user;

  @override
  initState() {
    super.initState();
    session = Session();
    session.isSignedIn().then((result) {
      if (result != null) {
        setState(() {
          user = result;
        });
      }
    });
    Vibrate.canVibrate.then((value) {
      canVibrate = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        // You need to add them if you are using the material library.
        // The material components uses this delegates to provide default
        // localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      onGenerateTitle: (BuildContext context) => S.of(context).appTitle,
      title: 'Climbing app',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          })),
      theme: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.redAccent),
          primarySwatch: Colors.teal,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          })),
      home: GymsList(
        user: user,
        signOut: () {
          session.signOut().then((result) {
            setState(() {
              user = result;
            });
          });
        },
        signInGoogle: () {
          session.signInGoogle().then((result) {
            if (result != null) {
              setState(() {
                user = result;
              });
            }
          });
        },
        signInApple: () {
          session.signInApple().then((result) {
            if (result != null) {
              setState(() {
                user = result;
              });
            }
          });
        },
        register: () {
          setState(() {
            session.register();
            user = session.user;
          });
        },
        openSettings: () {
          setState(() {
            // Place code for opening settings
          });
        },
        editAccount: () {},
      ),
    );
  }
}
