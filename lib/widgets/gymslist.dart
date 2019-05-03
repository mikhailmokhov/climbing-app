import 'package:climbing/classes/gym.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'gymprops.dart';

class GymList extends StatefulWidget {
  static const String routeName = '/gymlist';

  const GymList({Key key}) : super(key: key);

  @override
  _GymListState createState() => _GymListState();
}

class _GymListState extends State<GymList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _dense = true;
  bool _showAvatars = true;
  bool _showIcons = true;
  List<Gym> items = [];

  Future<void> _handleRefresh() async {
    const USE_CACHE = true;
    const String EXPIRATION = '_expiration';

    loadGyms(dynamic jsonMap) {
      if (jsonMap['results'] is List) {
        items = [];
        jsonMap['results'].forEach((gymMap) {
          items.add(Gym.fromGoogleJson(gymMap));
        });
      }
    }

    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
    if (position == null) {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    }

    double latitude = position.latitude;
    double longitude = position.longitude;

    String dataKey =
        latitude.toStringAsFixed(1) + ',' + longitude.toStringAsFixed(1);
    String expirationKey = dataKey + EXPIRATION;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (USE_CACHE &&
        preferences.containsKey(dataKey) &&
        preferences.containsKey(expirationKey) &&
        (DateTime.fromMillisecondsSinceEpoch(preferences.getInt(expirationKey))
            .isAfter(DateTime.now()))) {
      loadGyms(json.decode(preferences.getString(dataKey)));
    } else {
      final response = await http.get(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
              latitude.toString() +
              ',' +
              longitude.toString() +
              '&rankby=distance&keyword=' +
              KEYWORD +
              '&key=' +
              APP_KEY);
      if (response.statusCode == 200) {
        preferences.setString(dataKey, response.body);
        preferences.setInt(dataKey + EXPIRATION,
            (DateTime.now()).add(Duration(days: 1)).millisecondsSinceEpoch);
        loadGyms(json.decode(response.body));
      } else {
        // If that response was not OK, throw an error.
        //throw Exception('Failed to load post');
        _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState.show();
            },
          ),
        ));
      }
    }
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    _handleRefresh().then((_) {
      setState(() {
        items = items;
      });
    });
  }

  _onTap(Gym gym) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsDemo(gym)),
    );
    //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(gym.name)));
  }

  Widget buildListTile(BuildContext context, String item) {
    Widget secondary;

    secondary = const Text(
      'Even more additional list item information appears on line three.',
    );

    return MergeSemantics(
      child: ListTile(
        dense: _dense,
        leading: _showAvatars
            ? ExcludeSemantics(child: CircleAvatar(child: Text(item)))
            : null,
        title: Text('This item represents $item.'),
        subtitle: secondary,
        trailing: _showIcons
            ? Icon(Icons.info, color: Theme.of(context).disabledColor)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Climbing gyms'),
          leading: IconButton(
            icon: const Icon(Icons.dehaze),
            tooltip: 'Refresh',
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              },
            ),
          ]),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: items.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 0),
          itemBuilder: (BuildContext context, int index) {
            final Gym gym = items[index];
            return ListTile(
                dense: false,
                isThreeLine: true,
                onTap: () {
                  _onTap(gym);
                },
                trailing: FadeInImage.assetNetwork(
                    placeholder: 'images/gym-placeholder.jpg',
                    image: gym.getGooglePhotoUrl(APP_KEY),
                    width: 75,
                    height: 55,
                    fit: BoxFit.cover),
                title: Text(gym.name),
                subtitle: Column(children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(gym.googleRating.toString() + ' ',
                        style: TextStyle(color: Colors.deepOrangeAccent)),
                    FlutterRatingBarIndicator(
                      rating: gym.googleRating,
                      fillColor: Colors.deepOrangeAccent,
                      emptyColor: Colors.grey.withAlpha(150),
                      itemCount: 5,
                      itemSize: 11,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                    ),
                    Text(' (' + gym.googleUserRatingsTotal.toString() + ')  ',
                        style: TextStyle(color: Colors.grey.withAlpha(150))),
                  ]),
                  Row(
                    children: <Widget>[Text(gym.city)],
                  )
                ]));
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Alex Honnold'),
              accountEmail: Text('alex.honnold@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/honnold.png'),
              ),
              margin: EdgeInsets.zero,
            ),
            MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: ListTile(
                  trailing: Icon(Icons.delete_sweep),
                  title: Text('Clear cache'),
                  onTap: () {
                    SharedPreferences.getInstance().then((pref) {
                      pref.clear();
                      _scaffoldKey.currentState?.showSnackBar(SnackBar(
                        content: const Text('Cache cleared'),
                      ));
                      Navigator.of(context).pop();
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
