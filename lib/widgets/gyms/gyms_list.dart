import 'package:climbing/classes/gyms_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:climbing/classes/gym_class.dart';
import 'package:climbing/classes/my_location.dart';
import 'package:climbing/generated/l10n.dart';

import 'gyms_list_add_to_yelp.dart';
import 'gyms_list_tile_yelp.dart';
import 'gyms_view.dart';

enum ViewMode { list, map }

class GymsList extends StatefulWidget {
  final Function refreshList;
  final Function(Gym gym, BuildContext context) gymOnTap;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final List<Gym> gyms;
  final Coordinates coordinates;
  final GymsProvider provider;
  final GymListViewMode gymListViewMode;

  GymsList(this.refreshList, this.gymOnTap, this.refreshIndicatorKey, this.gyms,
      this.coordinates, this.provider, this.gymListViewMode,
      {Key key})
      : super(key: key);

  @override
  _GymsListState createState() => _GymsListState();
}

class _GymsListState extends State<GymsList> {
  @override

  Widget build(BuildContext context) {
    List visibleWidgets;
    switch (widget.gymListViewMode) {
      case GymListViewMode.allGyms:
         visibleWidgets = widget.gyms.where((widget) => widget.hidden == false).toList();
        break;
      case GymListViewMode.hiddenGyms:
        visibleWidgets = widget.gyms.where((widget) => widget.hidden == true).toList();
        break;
    }
    int length = visibleWidgets.length;
    return Container(
        child: ListView.separated(
      itemCount: length + 2,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 0.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == length + 1) {
          return widget.provider == GymsProvider.YELP
              ? AddItToYelp()
              : Container(
                  height: 65,
                  child: ListTile(
                      title: widget.provider == GymsProvider.GOOGLE
                          ? Image.asset(
                              'images/powered_by_google_on_white2x.png',
                              scale: 2.5,
                            )
                          : null));
        } else if (index == 0 && length > 0) {
          return Container(
              margin: EdgeInsets.only(left: 16.0, top: 7, bottom: 10),
              child: Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.place,
                    size: 19,
                  ),
                ),
                Text(
                  S.of(context).near + " " + visibleWidgets[0].city,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              ]));
        }
        if (length == 0) return Container();
        final Gym gym = visibleWidgets[index > 0 ? index - 1 : index];

        return widget.provider == GymsProvider.YELP
            ? GymsListTileYelp(widget.gymOnTap, gym)
            : Container(
                child: ListTile(
                    dense: false,
                    isThreeLine: true,
                    onTap: () {
                      widget.gymOnTap(gym, context);
                    },
                    trailing: new ClipRRect(
                      borderRadius: new BorderRadius.circular(2.0),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'images/gym-placeholder.jpg',
                          image: gym.getImageUrl() != null
                              ? gym.getImageUrl()
                              : 'https://birkeland.uib.no/wp-content/themes/bcss/images/no.png',
                          width: 75,
                          height: 55,
                          fit: BoxFit.cover),
                    ),
                    title: Text(
                      gym.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(gym.rating.toString() + ' ',
                                    style: TextStyle(
                                        color: Colors.deepOrangeAccent)),
                                RatingBarIndicator(
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  rating: gym.rating,
                                  alpha: 0,
                                  itemCount: 5,
                                  itemSize: 11,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.5),
                                ),
                                Text(' (' + gym.ratingsCount.toString() + ')  ')
                              ]),
                          Row(
                            children: <Widget>[Text(gym.city)],
                          )
                        ])));
      },
    ));
  }
}
