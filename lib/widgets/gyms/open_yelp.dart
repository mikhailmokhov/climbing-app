import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_appavailability/flutter_appavailability.dart';

class OpenYelp extends StatelessWidget {
  final String url;
  final double opacity;

  OpenYelp(this.url, this.opacity, {Key key}) : super(key: key);

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
    return  Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.asset("res/yelp/logo_default@2x.png",
            width: 44,
            color: Color.fromRGBO(255, 255, 255, opacity),
            colorBlendMode: BlendMode.modulate),
      ),
    );
  }
}
