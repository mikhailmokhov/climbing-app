import 'package:climbing/generated/l10n.dart';
import 'package:climbing/models/coordinates.dart';
import 'package:climbing/models/gym.dart';
import 'package:climbing/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../screens/gym_screen.dart';

class GymsMap extends StatefulWidget {
  const GymsMap(
      {Key key,
      @required this.gyms,
      @required this.coordinates,
      @required this.updateCoordinates,
      @required this.updateUser,
      @required this.signIn})
      : super(key: key);

  final List<Gym> gyms;
  final Coordinates coordinates;
  final UpdateCoordinatesCallback updateCoordinates;
  final UpdateUserCallback updateUser;
  final SignInCallback signIn;

  @override
  _GymsMapState createState() => _GymsMapState();
}

class _GymsMapState extends State<GymsMap> {
  final Map<String, Marker> _markers = <String, Marker>{};
  GoogleMapController mapController;
  Coordinates mapCenterCoordinates;

  Future<void> createMarkers() async {
    setState(() {
      _markers.clear();
      for (final Gym gym in widget.gyms) {
        final Marker marker = Marker(
          markerId: MarkerId(gym.getImageUrl()),
          position: LatLng(
              gym.yelpCoordinates.latitude, gym.yelpCoordinates.longitude),
          infoWindow: InfoWindow(
            onTap: () {
              Navigator.pushNamed(context, GymScreen.routeName,
                  arguments: GymScreenArguments(gym));
            },
            title: gym.getName(),
            snippet: gym.city,
          ),
        );
        _markers[gym.yelpCoordinates.toString()] = marker;
      }

      if (mapController != null)
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    widget.coordinates.latitude, widget.coordinates.longitude),
                zoom: 10.0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    createMarkers();
    final ThemeData themeData = Theme.of(context);

    return Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: (GoogleMapController controller) async {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target:
              LatLng(widget.coordinates.latitude, widget.coordinates.longitude),
          zoom: 10,
        ),
        markers: Set<Marker>.of(_markers.values),
      ),
      //SEARCH THIS AREA action button
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
              height: 33.0,
              child: FloatingActionButton.extended(
                backgroundColor: themeData.scaffoldBackgroundColor,
                foregroundColor: themeData.textTheme.bodyText2.color,
                onPressed: () {
                  mapController
                      .getVisibleRegion()
                      .then((LatLngBounds latLngBounds) {
                    widget
                        .updateCoordinates(_getCenterCoordinates(latLngBounds));
                  });
                },
                label: Text(
                  S.of(context).searchThisArea,
                  style: const TextStyle(letterSpacing: 0.3),
                ),
              )),
        ),
      )
    ]);
  }
}

Coordinates _getCenterCoordinates(LatLngBounds latLngBounds) {
  return Coordinates(
      (latLngBounds.southwest.latitude + latLngBounds.northeast.latitude) / 2,
      (latLngBounds.southwest.longitude + latLngBounds.northeast.longitude) /
          2);
}
