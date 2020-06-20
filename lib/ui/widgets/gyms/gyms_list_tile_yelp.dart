import 'package:climbing/models/gym.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/screens/gym_screen.dart';
import 'package:climbing/screens/gyms_screen.dart';
import 'package:climbing/ui/widgets/gyms/rating_bar_yelp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GymsListTileYelp extends StatelessWidget {
  const GymsListTileYelp({
    Key key,
    @required this.gym,
    @required this.user,
  }) : super(key: key);


  final Gym gym;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
            dense: false,
            isThreeLine: true,
            onTap: () {
              Navigator.pushNamed(context, GymScreen.routeName,
                  arguments: GymScreenArguments(gym));
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/gym-placeholder.jpg',
                  image: gym.yelpImageUrl ??
                      'https://birkeland.uib.no/wp-content/themes/bcss/images/no.png',
                  width: 75,
                  height: 55,
                  fit: BoxFit.cover),
            ),
            title: Text(
              gym.getName(),
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
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          gym.city,
                          style: const TextStyle(fontSize: 13),
                        ),
                      )
                    ]),
                Expanded(
                  child: user != null &&
                          user.bookmarks != null &&
                          gym.id != null &&
                          user.bookmarks.contains(gym.id)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[
                            Icon(
                              Icons.bookmark,
                              color: Colors.redAccent,
                            )
                          ],
                        )
                      : const Text(''),
                )
              ],
            )));
  }
}
