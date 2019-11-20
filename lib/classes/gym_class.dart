import 'package:climbing/classes/places_api.dart';

import 'climbing_route_class.dart';

///
/// Describes properties and serialization methods of gym instance
class Gym {
  final String id;
  final String name;
  final String city;
  List<ClimbingRoute> routes;

  /// Google specific fields
  final String googlePlaceId;
  final List<PlacesPhoto> googlePhotos = [];
  final double googleRating;
  final int googleUserRatingsTotal;
  final double lat;
  final double lng;

  /// Google specific method
  static String _getCityFromVicinity(String vicinity) {
    List<String> list = vicinity.split(',');
    if (list.length > 1) {
      return list.last.trim();
    } else {
      return vicinity;
    }
  }

  /// Google specific deserializer from Places API json response
  Gym.fromGoogleJson(Map<String, dynamic> json)
      : this.id = '',
        this.routes = [],
        this.googlePlaceId = json['place_id'],
        this.name = json['name'],
        this.lat = json['geometry']['location']['lat'],
        this.lng = json['geometry']['location']['lng'],
        this.city = json.containsKey('city')
            ? json['city']
            : _getCityFromVicinity(json['vicinity']),
        this.googleRating = (json['rating'] is int || json['rating'] is double)
            ? json['rating'].toDouble()
            : null,
        this.googleUserRatingsTotal = (json['user_ratings_total'] is int)
            ? json['user_ratings_total']
            : null {
    if (json['photos'] is List)
      for (final photo in json['photos'])
        this.googlePhotos.add(PlacesPhoto.fromJson(photo));
  }

  /// Google specific method for obtaining Places Photos URL
  String getGooglePhotoUrl({int width}) {
    if (this.googlePhotos.length > 0) {
      return this.googlePhotos[0].getUrl(width: width);
    } else {
      return '';
    }
  }

  /// Generic serializer
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> googlePhotos = [];
    for (final photo in this.googlePhotos) googlePhotos.add(photo.toJson());
    return {
      'id': this.id,
      'place_id': this.googlePlaceId,
      'name': this.name,
      'user_ratings_total': this.googleUserRatingsTotal,
      'rating': this.googleRating,
      'city': this.city,
      'lng':this.lng,
      'lat':this.lat,
      'google_photos': googlePhotos
    };
  }
}