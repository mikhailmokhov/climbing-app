import 'package:climbing/classes/places_api.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:climbing/classes/gym_class.dart';
import 'package:climbing/classes/location.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:climbing/widgets/drawer_menu_widget.dart';
import 'package:vibrate/vibrate.dart';
import '../main.dart';
import 'gym_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ViewMode { list, map }

class GymsList extends StatefulWidget {
  static const String routeName = '/gymslist';
  final User user;
  final Function signOut;
  final Function signInGoogle;
  final Function signInApple;
  final Function register;
  final Function openSettings;
  final Function editAccount;

  GymsList({
    @required this.user,
    @required this.signOut,
    @required this.signInGoogle,
    @required this.signInApple,
    @required this.register,
    @required this.openSettings,
    @required this.editAccount,
    Key key,
  }) : super(key: key);

  @override
  _GymsListState createState() => _GymsListState();
}

class _GymsListState extends State<GymsList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, Marker> _markers = {};
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ViewMode viewMode = ViewMode.list;
  GoogleMapController mapController;

  List<Gym> items = [];
  Coordinates coordinates;

  Future<void> _handleRefresh() async {
    coordinates = await Location.getCoordinates();

    PlacesApi.nearbySearch(coordinates.latitude, coordinates.longitude, context)
        .then((fetchedItems) {
      setState(() {
        items = fetchedItems;
      });
    }).catchError((Object error) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(error.toString()),
        action: SnackBarAction(
          label: S.of(context).RETRY,
          onPressed: () {
            _refreshIndicatorKey.currentState.show();
          },
        ),
      ));
    });
  }

  @override
  initState() {
    super.initState();
    _handleRefresh();
  }

  void _loadMore() {
    //print('Load more');
  }

  _onTap(Gym gym) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GymWidget(gym)),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  refreshMap() async {
    final CameraPosition _kLake = CameraPosition(
        target: LatLng(coordinates.latitude, coordinates.longitude),
        zoom: 10.0);

    setState(() {
      _markers.clear();
      for (final gym in items) {
        final marker = Marker(
          markerId: MarkerId(gym.name),
          position: LatLng(gym.lat, gym.lng),
          infoWindow: InfoWindow(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GymWidget(gym)),
              );
            },
            title: gym.name,
            snippet: gym.city,
          ),
        );
        _markers[gym.name] = marker;
      }

      if (mapController != null)
        mapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    });
  }

  @override
  Widget build(BuildContext context) {
    int length = items.length;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(S.of(context).gymsList_title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: S.of(context).menu,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            viewMode == ViewMode.list
                ? IconButton(
                    icon: const Icon(Icons.map),
                    tooltip: S.of(context).switchToMapView,
                    onPressed: () {
                      setState(() {
                        viewMode = ViewMode.map;
                        refreshMap();
                      });
                      if (canVibrate) Vibrate.feedback(FeedbackType.selection);
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.list),
                    tooltip: S.of(context).switchToListView,
                    onPressed: () {
                      setState(() {
                        viewMode = ViewMode.list;
                      });
                      if (canVibrate) Vibrate.feedback(FeedbackType.selection);
                    },
                  ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: S.of(context).refresh,
              onPressed: () {
                if (viewMode == ViewMode.list) {
                  _handleRefresh();
                  _refreshIndicatorKey.currentState.show();
                } else {
                  refreshMap();
                }
              },
            ),
          ]),
      body: viewMode == ViewMode.list
          ? RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _loadMore();
                  }
                  return true;
                },
                child: Container(
                    child: ListView.separated(
                  itemCount: length + 2,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 0.0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == length + 1) {
                      return Container(
                          height: 65,
                          child: ListTile(
                              title: Image.asset(
                            'images/powered_by_google_on_white2x.png',
                            scale: 2.5,
                          )));
                    } else if (index == 0 && length > 0) {
                      return Container(
                          margin:
                              EdgeInsets.only(left: 16.0, top: 7, bottom: 10),
                          child: Row(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.place,
                                size: 19,
                              ),
                            ),
                            Text(
                              items[0].city,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ]));
                    }
                    if (length == 0) return Container();
                    final Gym gym = items[index > 0 ? index - 1 : index];

                    return Container(
                        child: ListTile(
                            dense: false,
                            isThreeLine: true,
                            onTap: () {
                              _onTap(gym);
                            },
                            trailing: FadeInImage.assetNetwork(
                                placeholder: 'images/gym-placeholder.png',
                                image: gym.getGooglePhotoUrl(),
                                width: 75,
                                height: 55,
                                fit: BoxFit.cover),
                            title: Text(
                              gym.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(gym.googleRating.toString() + ' ',
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent)),
                                    RatingBarIndicator(
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      rating: gym.googleRating,
                                      alpha: 0,
                                      itemCount: 5,
                                      itemSize: 11,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.5),
                                    ),
                                    Text(' (' +
                                        gym.googleUserRatingsTotal.toString() +
                                        ')  ')
                                  ]),
                              Row(
                                children: <Widget>[Text(gym.city)],
                              )
                            ])));
                  },
                )),
              ),
            )
          : Stack(children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: coordinates == null
                      ? const LatLng(45.521563, -122.677433)
                      : LatLng(coordinates.latitude, coordinates.longitude),
                  zoom: 10,
                ),
                markers: Set<Marker>.of(_markers.values),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      height: 33.0,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          mapController
                              .getVisibleRegion()
                              .then((LatLngBounds latLngBounds) {
                            coordinates.latitude =
                                (latLngBounds.southwest.latitude +
                                        latLngBounds.northeast.latitude) /
                                    2;
                            coordinates.longitude =
                                (latLngBounds.southwest.longitude +
                                        latLngBounds.northeast.longitude) /
                                    2;
                            PlacesApi.nearbySearch(coordinates.latitude,
                                    coordinates.longitude, context)
                                .then((fetchedItems) {
                              setState(() {
                                items = fetchedItems;
                              });
                              refreshMap();
                            });
                          });
                          if (canVibrate)
                            Vibrate.feedback(FeedbackType.selection);
                        },
                        label: Text(
                          S.of(context).searchThisArea,
                        ),
                      )),
                ),
              )
            ]),
      drawer: DrawerMenu(
          this.widget.user,
          this.widget.signOut,
          this.widget.signInGoogle,
          this.widget.signInApple,
          this.widget.register,
          this.widget.openSettings),
    );
  }
}
