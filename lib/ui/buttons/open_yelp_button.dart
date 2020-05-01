import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenYelpButton extends StatelessWidget {
  final String url;
  final double opacity;
  final double width;

  OpenYelpButton({@required this.url, @required this.opacity, @required this.width, Key key, })
      : super(key: key);

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
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.asset("assets/yelp/logo_default@2x.png",
            width: this.width,
            color: Color.fromRGBO(255, 255, 255, opacity),
            colorBlendMode: BlendMode.modulate),
      ),
    );
  }
}
