import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/ui/widgets/gyms/gyms_view.dart';
import 'package:climbing/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vibrate/vibrate.dart';
import 'models/sign_in_with_apple_response.dart';
import 'services/api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static const String STORAGE_KEY_USER = 'user';
  final bool isGoogleSignInAvailable = true;
  final canVibrate = Vibrate.canVibrate;
  final Set<SignInProvider> signInProviderSet = Set();
  bool _inAsyncCall = false;
  User user;

  void updateUserCallback(User updatedUser) {
    FlutterSecureStorage()
        .write(key: STORAGE_KEY_USER, value: json.encode(this.user.toJson()));
    setState(() {
      this.user = updatedUser;
    });
  }

  signIn(SignInProvider signInProvider) async {
    switch (signInProvider) {
    // APPLE SIGN IN
      case SignInProvider.Apple:
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);
        switch (result.status) {
          case AuthorizationStatus.authorized:
            finishAppleSignIn(result.credential);
            break;
          case AuthorizationStatus.error:
          //TODO: handle authorization error
            break;
          case AuthorizationStatus.cancelled:
          //TODO: handle case when user cancelled
            break;
        }
        break;
    // GOOGLE SIGN IN
      case SignInProvider.Google:
      // TODO: Handle this case.
        break;
    }
  }

  void signOut(){
    FlutterSecureStorage().delete(key: STORAGE_KEY_USER);
    ApiService.logout();
    setState(() {
      user = null;
    });
  }

  @override
  initState() {
    super.initState();
    AppleSignIn.isAvailable().then((isAvailable) {
      if (!isAvailable) return;
      checkLoggedInState();
      setState(() {
        signInProviderSet.add(SignInProvider.Apple);
      });
    });
    AppleSignIn.onCredentialRevoked.listen((_) {
      signOut();
    });
  }

  finishAppleSignIn(AppleIdCredential appleIdCredential) {
    // Start progress spinner
    setState(() {
      _inAsyncCall = true;
    });
    ApiService.appleSignIn(appleIdCredential)
        .then((SignInWithAppleResponse signInWithAppleResponse) {
      assert(signInWithAppleResponse != null &&
          signInWithAppleResponse.user != null);
      ApiService.token = signInWithAppleResponse.user.token;
      FlutterSecureStorage().write(
          key: STORAGE_KEY_USER,
          value: json.encode(signInWithAppleResponse.user.toJson()));
      setState(() {
        this.user = signInWithAppleResponse.user;
        this._inAsyncCall = false;
      });
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
        title: 'Routesetter',
        themeMode: ThemeMode.system,
        darkTheme: darkThemeData,
        theme: lightThemeData,
        home: ModalProgressHUD(
          inAsyncCall: _inAsyncCall,
          child: GymsView(
            user: user,
            signOut: signOut,
            signIn: signIn,
            editAccount: () {},
            updateUserCallback: updateUserCallback,
            signInProviderSet: signInProviderSet,
          ),
        ));
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
        ApiService.token = storedUser.token;
        ApiService.getUser().then((user) {
          setState(() {
            this.user = user;
          });
        }).catchError(() {
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
