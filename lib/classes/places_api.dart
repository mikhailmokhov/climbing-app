import 'dart:convert';
import 'package:climbing/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'gym_class.dart';

const String PLACES_APP_KEY = 'AIzaSyCJ4u7HC3AsvOMS_4w-mdkhLOP_deCLBcc';

class PlacesApi {
  static const String KEYWORD = 'climbing%20gym';

  static Future<List<Gym>> nearbySearch(
      double lat, double lng, BuildContext context) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            lat.toString() +
            ',' +
            lng.toString() +
            '&rankby=distance&keyword=' +
            KEYWORD +
            '&key=' +
            PLACES_APP_KEY +
            '&language=' +
            Localizations.localeOf(context).languageCode;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = json.decode(response.body);
      if(jsonMap.containsKey('error_message')){
        throw jsonMap['error_message'];
      } else if (jsonMap['results'] is List) {
        List<Gym> items = [];
        jsonMap['results'].forEach((gymMap) {
          items.add(Gym.fromGoogleJson(gymMap));
        });
        return items;
      } else {
        throw S.of(context).requestError;
      }
    } else {
      throw S.of(context).requestError;
    }
  }
}

/// Describes Place Photo instance, part of the Places API
class PlacesPhoto {
  final String reference;

  PlacesPhoto.fromJson(Map<String, dynamic> json)
      : this.reference = json['photo_reference'];

  Map<String, dynamic> toJson() => {'photo_reference': this.reference};

  String getUrl({int width}) {
    width ??= 300;
    return 'https://maps.googleapis.com/maps/api/place/photo?key=' +
        PLACES_APP_KEY +
        '&photoreference=' +
        this.reference +
        '&maxwidth=' +
        width.toString();
  }
}

//const USE_CACHE = false;
//const String EXPIRATION = '_expiration';
//refreshMap(LatLng(coordinates.latitude, coordinates.longitude));
//    String dataKey = coordinates.latitude.toStringAsFixed(1) +
//        ',' +
//        coordinates.longitude.toStringAsFixed(1);
//    String expirationKey = dataKey + EXPIRATION;

//    SharedPreferences preferences = await SharedPreferences.getInstance();

//    if (USE_CACHE &&
//        preferences.containsKey(dataKey) &&
//        preferences.containsKey(expirationKey) &&
//        (DateTime.fromMillisecondsSinceEpoch(preferences.getInt(expirationKey))
//            .isAfter(DateTime.now()))) {
//      loadGyms(json.decode(preferences.getString(dataKey)));
//    } else {
//preferences.setString(dataKey, response.body);
//preferences.setInt(dataKey + EXPIRATION,
//          (DateTime.now())
//              .add(Duration(days: 1))
//              .millisecondsSinceEpoch);
// If that response was not OK, throw an error.
//throw Exception('Failed to load post');
