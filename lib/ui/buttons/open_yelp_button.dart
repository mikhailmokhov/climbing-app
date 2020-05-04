import 'package:climbing/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenYelpButton extends StatelessWidget {
  final String url;

  OpenYelpButton({
    @required this.url,
    Key key,
  }) : super(key: key);

  _launchURL() async {
    //TODO add code for handling launching Yelp app
    //yelp4:///search?terms=Coffee
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return             Container(
      child: Tooltip(
        message: S.of(context).openYelpPage,
        child: SizedBox(
          width: 62,
          child: OutlineButton(
              padding: EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              onPressed: _launchURL,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/yelp/logo_default@2x.png",
                    height: 21,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
