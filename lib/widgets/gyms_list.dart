import 'dart:convert';
import 'package:climbing/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:climbing/classes/gym.dart';
import 'package:climbing/classes/location.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:climbing/widgets/drawer_menu.dart';
import 'gymprops.dart';
import '../main.dart';

class GymsList extends StatefulWidget {
  final User user;
  final Function signOut;
  final Function signIn;
  final Function register;
  static const String routeName = '/gymslist';

  const GymsList(
      {@required this.user,
      @required this.signOut,
      @required this.signIn,
      @required this.register,
      Key key})
      : super(key: key);

  @override
  _GymsListState createState() => _GymsListState();
}

class _GymsListState extends State<GymsList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _dense = true;
  bool _showAvatars = true;
  bool _showIcons = true;
  List<Gym> items = [];

  Future<void> _handleRefresh() async {
    const USE_CACHE = false;
    const String EXPIRATION = '_expiration';

    loadGyms(dynamic jsonMap) {
      if (jsonMap['results'] is List) {
        items = [];
        jsonMap['results'].forEach((gymMap) {
          items.add(Gym.fromGoogleJson(gymMap));
        });
      }
    }

    Coordinates coordinates = await Location.getCoordinates();

    String dataKey = coordinates.latitude.toStringAsFixed(1) +
        ',' +
        coordinates.longitude.toStringAsFixed(1);
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
              coordinates.latitude.toString() +
              ',' +
              coordinates.longitude.toString() +
              '&rankby=distance&keyword=' +
              KEYWORD +
              '&key=' +
              GOOGLE_PLACES_APP_KEY);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        if (jsonMap['results'] is List) {
          Gyms.fromGoogleJson(jsonMap['results']);
        }

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

  void _loadMore() {}

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
          title: Text(S.of(context).gymsList_title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: S.of(context).menu,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: S.of(context).refresh,
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              },
            ),
          ]),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _loadMore();
            }
          },
          child: ListView.separated(
            itemCount: items.length,
            padding: EdgeInsets.symmetric(vertical: 8.0),
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
                      image: gym.getGooglePhotoUrl(GOOGLE_PLACES_APP_KEY),
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
      ),
      drawer: DrawerMenu(this.widget.user, this.widget.signOut,
          this.widget.signIn, this.widget.register),
    );
  }
}
