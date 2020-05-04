import 'package:flutter/cupertino.dart';

import 'gyms/rating_bar_yelp.dart';

class GymTitleYelp extends StatelessWidget {
  final String gymName;
  final double rating;
  final int reviewCount;

  const GymTitleYelp(this.gymName, this.rating, this.reviewCount, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gymName,
            style: TextStyle(fontSize: 25),
          ),
          Padding(
            padding: EdgeInsets.only(top: 3, left: 2),
            child: YelpRatingBar(rating, reviewCount),
          )
        ],
      ),
    ),);
  }
}
