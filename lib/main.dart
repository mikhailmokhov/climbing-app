import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/widgets/gyms/gyms_view.dart';
import 'package:climbing/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vibrate/vibrate.dart';
import 'services/api_service.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

void main() => runApp(
    ProgressDialog(
      child: MyApp(),
    ));


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static const String STORAGE_KEY_USER = 'user';
  final bool isGoogleSignInAvailable = true;

  ApiService api;
  final canVibrate = Vibrate.canVibrate;
  User user;
  bool isAppleSignInAvailable = false;

  Future<bool> updateUser(User user){
    setState(() {
      this.user = user;
    });
    return ApiService.updateUser(this.user);
  }

  @override
  initState() {
    super.initState();
    AppleSignIn.isAvailable().then((isAvailable) {
      setState(() {
        isAppleSignInAvailable = isAvailable;
        checkLoggedInState();
      });
    });
    AppleSignIn.onCredentialRevoked.listen((_) {
      if (user != null) ApiService.logout();
      //TODO: add logic for revoked credentials
      setState(() {
        print('Credentials revoked');
        user = null;
      });
    });
  }

  @override
  void dispose() {
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
          FlutterSecureStorage().delete(key: STORAGE_KEY_USER);
          ApiService.logout().then((response) {
            print(response);
          });
          setState(() {
            user = null;
          });
        },
        signedIn: (user) {
          ApiService.uuid = user.uuid;
          FlutterSecureStorage()
              .write(key: STORAGE_KEY_USER, value: json.encode(user.toJson()));
          setState(() {
            this.user = user;
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
        isGoogleSignInAvailable: isGoogleSignInAvailable,
        api: api,
        canVibrate: canVibrate,
        updateUser: updateUser,
      ),
    );
  }

  void checkLoggedInState() async {
    final String savedUserJsonString =
        await FlutterSecureStorage().read(key: STORAGE_KEY_USER);
    if (savedUserJsonString == null) return;
    User storedUser = User.fromJson(json.decode(savedUserJsonString));
    if (storedUser.appleIdCredentialUser == null) return;
    final credentialState =
        await AppleSignIn.getCredentialState(storedUser.appleIdCredentialUser);
    switch (credentialState.status) {
      case CredentialStatus.authorized:
        ApiService.uuid = storedUser.uuid;
        ApiService.getUser().then((user){
          setState(() {
            this.user = user;
          });
        }).catchError((){
          setState(() {
            this.user = storedUser;
          });
        });
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
