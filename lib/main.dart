import 'package:climbing/classes/session.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:climbing/widgets/gyms_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const String GOOGLE_PLACES_APP_KEY = 'AIzaSyCJ4u7HC3AsvOMS_4w-mdkhLOP_deCLBcc';
const String KEYWORD = 'climbing%20gym';
const String LOCATION = '43.640454,-79.380488';

void main() => runApp(MyApp());

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
    session.signIn();
    user = session.user;
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GymsList(
          user: user,
          signOut: () {
            setState(() {
              session.signOut();
              user = session.user;
            });
          },
          signIn: () {
            setState(() {
              session.signIn();
              user = session.user;
            });
          },
          register: () {
            setState(() {
              session.register();
              user = session.user;
            });
          }),
    );
  }
}
