import 'package:climbing/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YelpRatingBar extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final String assetName;

  static final Map<double, String> assets = {
    0: "res/yelp/regular_0@2x.png",
    1: "res/yelp/regular_1@2x.png",
    1.5: "res/yelp/regular_1_half@2x.png",
    2: "res/yelp/regular_2@2x.png",
    2.5: "res/yelp/regular_2_half@2x.png",
    3: "res/yelp/regular_3@2x.png",
    3.5: "res/yelp/regular_3_half@2x.png",
    4: "res/yelp/regular_4@2x.png",
    4.5: "res/yelp/regular_4_half@2x.png",
    5: "res/yelp/regular_5@2x.png"
  };

  YelpRatingBar(double rating, int reviewCount, {Key key})
      : this.rating = rating == null ? 0 : rating,
        assetName = assets[rating == null ? 0 : rating],
        this.reviewCount = reviewCount == null ? 0 : reviewCount,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: const EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              assetName,
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                reviewCount.toString() + " " + S.of(context).reviews,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ));
  }
}
