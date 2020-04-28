import 'dart:io';

import 'package:climbing/models/sign_in_provider_enum.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/widgets/buttons/my_apple_sign_in_button.dart';
import 'package:climbing/widgets/buttons/my_google_sign_in_button.dart';
import 'package:flutter/material.dart';

class SignInDialog extends StatelessWidget {
  static const double CORNER_RADIUS = 4.0;
  static const double BUTTON_PADDING = 10;

  final Function(SignInProvider) signIn;
  final List<SignInProvider> providers;

  SignInDialog({Key key, @required this.signIn, @required this.providers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;

    List<Widget> items = [];
    //APPLE
    if (providers.indexOf(SignInProvider.Apple) != -1) {
      items.add(Padding(
          padding: const EdgeInsets.all(BUTTON_PADDING),
          child: MyAppleSignInButton(
              text: S.of(context).continueWithApple,
              style: brightness == Brightness.dark
                  ? AppleSignInButtonStyle.white
                  : AppleSignInButtonStyle.black,
              cornerRadius: CORNER_RADIUS,
              onPressed: () {
                this.signIn(SignInProvider.Apple);
                Navigator.pop(context);
              })));
    }
    //GOOGLE
    if (providers.indexOf(SignInProvider.Google) != -1) {
      items.add(Padding(
          padding: const EdgeInsets.all(BUTTON_PADDING),
          child: MyGoogleSignInButton(
              text: S.of(context).continueWithGoogle,
              style: brightness == Brightness.dark
                  ? AppleSignInButtonStyle.white
                  : AppleSignInButtonStyle.whiteOutline,
              cornerRadius: CORNER_RADIUS,
              onPressed: () {
                this.signIn(SignInProvider.Google);
                Navigator.pop(context);
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
}
