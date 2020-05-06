import 'package:climbing/models/gym.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/ui/widgets/gyms/rating_bar_yelp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GymsListTileYelp extends StatelessWidget {
  final Function(Gym gym, BuildContext context) onTap;
  final Gym gym;
  final User user;

  const GymsListTileYelp(this.onTap, this.gym, this.user, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
            dense: false,
            isThreeLine: true,
            onTap: () {
              onTap(gym, context);
            },
            leading: new ClipRRect(
              borderRadius: new BorderRadius.circular(2.0),
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/gym-placeholder.jpg',
                  image: gym.getImageUrl() != null
                      ? gym.getImageUrl()
                      //TODO replace image by an asset
                      : 'https://birkeland.uib.no/wp-content/themes/bcss/images/no.png',
                  width: 75,
                  height: 55,
                  fit: BoxFit.cover),
            ),
            title: Text(
              gym.name,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      YelpRatingBar(gym.yelpRating, gym.yelpReviewCount),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(gym.city, style: TextStyle(fontSize: 13),),
                      )
                    ]),
                Expanded(
                  child: user != null &&
                          user.homeGymIds != null &&
                          gym.id != null &&
                          user.homeGymIds.contains(gym.id)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.bookmark,
                              color: Colors.redAccent,
                            )
                          ],
                        )
                      : Text(""),
                )
              ],
            )));
  }
}
