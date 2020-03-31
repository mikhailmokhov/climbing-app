
import 'package:climbing/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddItToYelp extends StatelessWidget {
  final double fontSize = 13.0;
  static const url = "https://www.yelp.com/writeareview/newbiz";

  _launchURL() async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    // TODO: implement build
    return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(S.of(context).didntFindYourGym + " ",
              style: themeData.textTheme.body2.copyWith(
                  color: themeData.textTheme.caption.color,
                  fontSize: fontSize)),
          InkWell(
            onTap: _launchURL,
            child: Text(S.of(context).addItToYelp,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: fontSize - 1)),
          )
        ]));
  }
}
