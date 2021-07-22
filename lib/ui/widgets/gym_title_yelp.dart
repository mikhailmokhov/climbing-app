import 'package:flutter/cupertino.dart';

import 'gyms/rating_bar_yelp.dart';

class GymTitleYelp extends StatelessWidget {
  const GymTitleYelp(this.gymName, this.rating, this.reviewCount, {Key key})
      : super(key: key);

  final String gymName;
  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              gymName,
              style: const TextStyle(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 2),
              child: YelpRatingBar(rating, reviewCount),
            )
          ],
        ),
      ),
    );
  }
}
