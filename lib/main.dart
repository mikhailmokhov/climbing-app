import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:climbing/widgets/gyms/gyms_view.dart';
import 'package:climbing/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vibrate/vibrate.dart';
import 'classes/api.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  final bool isGoogleSignInAvailable = true;
   Api api;
  final canVibrate = Vibrate.canVibrate;
  User user;
  bool isAppleSignInAvailable = false;

  @override
  initState() {
    super.initState();
    //api.init("http:/192.168.50.25");
    AppleSignIn.isAvailable().then((isAvailable) {
      setState(() {
        isAppleSignInAvailable = isAvailable;
        checkLoggedInState();
      });
    });
    AppleSignIn.onCredentialRevoked.listen((_) {
      //TODO: add logic for revoked credentials
      setState(() {
        print('Credentials revoked');
        user = null;
      });
    });
  }
  
  @override
  void dispose() {
    //api.dispose();
    super.dispose();
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
      darkTheme: darkThemeData,
      theme: lightThemeData,
      home: GymsView(
        user: user,
        signOut: () {
          Api.logout().then((response){
            print(response);
          });
          setState(() {
            user = null;
          });
        },
        signedIn: (newUser) {
          setState(() {
            user = newUser;
          });
        },
        register: () {},
        openSettings: () {
          setState(() {
            // Place code for opening settings
          });
        },
        editAccount: () {},
        isAppleSignInAvailable: isAppleSignInAvailable,
        isGoogleSignInAvailable: isGoogleSignInAvailable, api: api, canVibrate: canVibrate,
      ),
    );
  }

  void checkLoggedInState() async {
    final userId = await FlutterSecureStorage().read(key: "appleUserId");
    if (userId == null) {
      print("No stored user ID");
      return;
    }

    final credentialState = await AppleSignIn.getCredentialState(userId);
    switch (credentialState.status) {
      case CredentialStatus.authorized:
        print("getCredentialState returned authorized");
        break;

      case CredentialStatus.error:
        print(
            "getCredentialState returned an error: ${credentialState.error.localizedDescription}");
        break;

      case CredentialStatus.revoked:
        print("getCredentialState returned revoked");
        break;

      case CredentialStatus.notFound:
        print("getCredentialState returned not found");
        break;

      case CredentialStatus.transferred:
        print("getCredentialState returned not transferred");
        break;
    }
  }
}
