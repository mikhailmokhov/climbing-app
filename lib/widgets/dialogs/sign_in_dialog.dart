import 'dart:io';

import 'package:climbing/classes/session.dart';
import 'package:climbing/widgets/buttons/my_apple_sign_in_button.dart';
import 'package:climbing/widgets/buttons/my_google_sign_in_button.dart';
import 'package:flutter/material.dart';

class SignInDialog extends StatelessWidget {
  static const double cornerRadius = 4.0;
  static const double buttonPadding = 10;
  final Function signIn;

  const SignInDialog({Key key, this.signIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> buttons = [
      // APPLE
      Padding(
          padding: const EdgeInsets.all(buttonPadding),
          child: MyAppleSignInButton(
            type: AppleSignInButtonType.signIn,
            style: Theme.of(context).brightness == Brightness.dark
                ? AppleSignInButtonStyle.white
                : AppleSignInButtonStyle.black,
            cornerRadius: cornerRadius,
            onPressed: () {
              signIn(SignWith.Apple);
            },
          )),
      // GOOGLE
      Padding(
          padding: const EdgeInsets.all(buttonPadding),
          child: MyGoogleSignInButton(
            type: AppleSignInButtonType.signIn,
            style: Theme.of(context).brightness == Brightness.dark
                ? AppleSignInButtonStyle.white
                : AppleSignInButtonStyle.whiteOutline,
            cornerRadius: cornerRadius,
            onPressed: () {
              signIn(SignWith.Google);
            },
          ))
    ];

    return SimpleDialog(
        contentPadding: EdgeInsets.only(top: 35, bottom: 35, left: 20, right: 20),
        children: !Platform.isIOS ? buttons.reversed.toList() : buttons);
  }
}
