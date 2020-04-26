import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:climbing/services/api_service.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/models/sign_in_with_apple_response.dart';
import 'package:climbing/widgets/buttons/my_apple_sign_in_button.dart';
import 'package:climbing/widgets/buttons/my_google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

class SignInDialog extends StatelessWidget {
  static const double CORNER_RADIUS = 4.0;
  static const double BUTTON_PADDING = 10;
  final Function(User) signedIn;
  final bool isAppleSignInAvailable;
  final bool isGoogleSignInAvailable;
  final ApiService api;

  SignInDialog(
      {Key key,
      @required this.signedIn,
      @required this.isAppleSignInAvailable,
      @required this.isGoogleSignInAvailable,
      @required this.api})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    closeDialog() {
      Navigator.pop(context);
    }

    Brightness brightness = Theme.of(context).brightness;

    List<Widget> items = [];
    //APPLE
    if (isAppleSignInAvailable) {
      items.add(Padding(
          padding: const EdgeInsets.all(BUTTON_PADDING),
          child: MyAppleSignInButton(
              text: S.of(context).continueWithApple,
              style: brightness == Brightness.dark
                  ? AppleSignInButtonStyle.white
                  : AppleSignInButtonStyle.black,
              cornerRadius: CORNER_RADIUS,
              onPressed: () {
                var dialog = showProgressDialog(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
                    loadingText: "", context: context);
                _signInWithApple().then((user) {
                  //pass user to parent widgets
                  dialog.dismiss();
                  signedIn(user);
                });
                closeDialog();
              })));
    }
    //GOOGLE
    if (isGoogleSignInAvailable) {
      items.add(Padding(
          padding: const EdgeInsets.all(BUTTON_PADDING),
          child: MyGoogleSignInButton(
              text: S.of(context).continueWithGoogle,
              style: brightness == Brightness.dark
                  ? AppleSignInButtonStyle.white
                  : AppleSignInButtonStyle.whiteOutline,
              cornerRadius: CORNER_RADIUS,
              onPressed: () {




               // closeDialog();
//                _signInWithGoogle().then((user) {
//                  //pass user to parent widgets
//                  signedIn(user);
//                });
              })));
    }

    if (!Platform.isIOS && items.length > 1) {
      // Show Google sign in first in case Android
      items = items.reversed.toList();
    }

    //FOOTER
    items.add(Padding(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: Text(
        S.of(context).byContinuingYouAcceptOurPolicies,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ));

    return SimpleDialog(
        contentPadding:
            const EdgeInsets.only(top: 35, bottom: 10, left: 20, right: 20),
        children: items);
  }

  Future<User> _signInWithApple() async {

    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        SignInWithAppleResponse response = await ApiService.appleSignIn(result.credential);
        return response.user;
        break;

      case AuthorizationStatus.error:
        //TODO: handle authorization error
        break;

      case AuthorizationStatus.cancelled:
        //TODO: handle case when user cancelled
        break;
    }

    return null;
  }

}
