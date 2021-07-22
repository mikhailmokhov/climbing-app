import 'dart:io';

import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/ui/buttons/my_apple_sign_in_button.dart';
import 'package:climbing/ui/buttons/my_google_sign_in_button.dart';
import 'package:flutter/material.dart';

class SignInDialog extends StatelessWidget {
  const SignInDialog(
      {Key key, @required this.signIn, @required this.signInProviderSet})
      : super(key: key);

  static const double CORNER_RADIUS = 4.0;
  static const double BUTTON_PADDING = 10;

  final Function(SignInProvider) signIn;
  final Set<SignInProvider> signInProviderSet;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    List<Widget> items = <Widget>[];
    //APPLE
    if (signInProviderSet.contains(SignInProvider.APPLE)) {
      items.add(Padding(
          padding: const EdgeInsets.all(BUTTON_PADDING),
          child: MyAppleSignInButton(
              text: S.of(context).continueWithApple,
              style: brightness == Brightness.dark
                  ? AppleSignInButtonStyle.white
                  : AppleSignInButtonStyle.black,
              cornerRadius: CORNER_RADIUS,
              onPressed: () {
                signIn(SignInProvider.APPLE);
                Navigator.pop(context);
              })));
    }
    //GOOGLE
    if (signInProviderSet.contains(SignInProvider.GOOGLE)) {
      items.add(Padding(
          padding: const EdgeInsets.all(BUTTON_PADDING),
          child: MyGoogleSignInButton(
              text: S.of(context).continueWithGoogle,
              style: brightness == Brightness.dark
                  ? AppleSignInButtonStyle.white
                  : AppleSignInButtonStyle.whiteOutline,
              cornerRadius: CORNER_RADIUS,
              onPressed: () {
                signIn(SignInProvider.GOOGLE);
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
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ));

    return SimpleDialog(
        contentPadding:
            const EdgeInsets.only(top: 35, bottom: 10, left: 20, right: 20),
        children: items);
  }
}
