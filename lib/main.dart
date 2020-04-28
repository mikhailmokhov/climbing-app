import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/models/sign_in_provider_enum.dart';
import 'package:climbing/widgets/gyms/gyms_view.dart';
import 'package:climbing/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vibrate/vibrate.dart';
import 'models/sign_in_with_apple_response.dart';
import 'services/api_service.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

void main() => runApp(ProgressDialog(
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
  List<SignInProvider> signInProviderList = [SignInProvider.Google];
  final canVibrate = Vibrate.canVibrate;

  ApiService api;
  User user;

  Future<bool> updateUser(User user) {
    setState(() {
      this.user = user;
    });
    return ApiService.updateUser(this.user);
  }

  @override
  initState() {
    super.initState();
    AppleSignIn.isAvailable().then((isAvailable) {
      if(isAvailable && signInProviderList.indexOf(SignInProvider.Apple)==-1){
        setState(() {
          signInProviderList.add(SignInProvider.Apple);
          checkLoggedInState();
        });
      }
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

  finishAppleSignIn(
      AppleIdCredential appleIdCredential, BuildContext context) {
    var dialog = showProgressDialog(
        backgroundColor: Theme
            .of(context)
            .primaryColor
            .withOpacity(0.7),
        loadingText: "",
        context: context);
    ApiService.appleSignIn(appleIdCredential)
        .then((SignInWithAppleResponse signInWithAppleResponse) {
      dialog.dismiss();
      if (signInWithAppleResponse == null ||
          signInWithAppleResponse.user == null)
        throw Exception("Invalid signInWithAppleResponse");
      ApiService.token = signInWithAppleResponse.user.token;
      FlutterSecureStorage()
          .write(key: STORAGE_KEY_USER, value: json.encode(signInWithAppleResponse.user.toJson()));
      setState(() {
        this.user = signInWithAppleResponse.user;
      });
    });
  }

  initiateSignIn(SignInProvider signInProvider, BuildContext context) async {
    switch (signInProvider) {
      // APPLE SIGN IN
      case SignInProvider.Apple:
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
        ]);
        switch (result.status) {
          case AuthorizationStatus.authorized:
            finishAppleSignIn(result.credential, context);
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
        signIn: (SignInProvider signInProvider, BuildContext context) {
          initiateSignIn(signInProvider, context);
        },
        register: () {},
        openSettings: () {
          setState(() {
            // Place code for opening settings
          });
        },
        editAccount: () {},
        api: api,
        canVibrate: canVibrate,
        updateUser: updateUser,
        signInProviderList: signInProviderList,
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
