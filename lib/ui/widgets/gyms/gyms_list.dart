import 'package:climbing/generated/l10n.dart';
import 'package:climbing/models/gym.dart';
import 'package:climbing/models/user.dart';
import 'package:flutter/material.dart';

import '../../../typedefs.dart';
import 'gyms_list_add_to_yelp.dart';
import 'gyms_list_tile_yelp.dart';

class GymsList extends StatefulWidget {
  const GymsList({Key key, @required this.gyms, @required this.user,  @required  this.fetchGyms})
      : super(key: key);

  final List<Gym> gyms;
  final User user;
  final FetchGymsCallback fetchGyms;

  @override
  _GymsListState createState() => _GymsListState();
}

class _GymsListState extends State<GymsList>{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> onRefresh(BuildContext context) async {
    return widget.fetchGyms(force: true);
  }

  @override
  Widget build(BuildContext context) {
    final int length = widget.gyms.length;
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        displacement: 60.0,
        onRefresh: () {
          return onRefresh(context);
        },
        child: Container(
            child: ListView.separated(
          itemCount: length + 2,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 0.0),
          itemBuilder: (BuildContext context, int index) {
            if (index == length + 1) {
              return AddItToYelp();
            } else if (index == 0 && length > 0) {
              return Container(
                  margin: const EdgeInsets.only(left: 16.0, top: 7, bottom: 10),
                  child: Row(children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.place,
                        size: 19,
                      ),
                    ),
                    Text(
                      S.of(context).nearWithCity(widget.gyms[0].yelpCity),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    )
                  ]));
            }
            if (length == 0) {
              return Container();
            }
            final Gym gym = widget.gyms[index > 0 ? index - 1 : index];
            return GymsListTileYelp(
              gym: gym,
              user: widget.user,
            );
          },
        )));
  }
}
