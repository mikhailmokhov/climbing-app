import 'package:climbing/models/my_location.dart';
import 'package:climbing/models/google_places_api.dart';

import 'climbing_route.dart';

//TODO create YelpBusiness class

///
/// Describes properties and serialization methods of gym instance
class Gym {
  final String id;
  final String name;
  final String city;
  List<ClimbingRoute> routes;

  /// Google specific fields
  final String googleId;
  final String yelpId;
  final String yelpImageUrl;
  final String yelpUrl;
  final double yelpRating;
  final int yelpReviewCount;
  final List<PlacesPhoto> googlePhotos = [];
  final double rating;
  final int ratingsCount;
  final Coordinates coordinates;
  final bool hidden;

  /// Google specific method
  static String _getCityFromVicinity(String vicinity) {
    List<String> list = vicinity.split(',');
    if (list.length > 1) {
      return list.last.trim();
    } else {
      return vicinity;
    }
  }

  Gym.fromYelpMap(Map<String, dynamic> json)
      : id = '',
        googleId = '',
        yelpRating = json['yelpRating'],
        yelpReviewCount = json['yelpReviewCount'],
        yelpId = json['id'],
        yelpUrl = json['yelpUrl'],
        routes = [],
        rating = json['rating'],
        ratingsCount = json['yelpReviewCount'],
        name = json['name'],
        coordinates = Coordinates(
            json['coordinates']['latitude'], json['coordinates']['longitude']),
        city = json['location']['city'],
        yelpImageUrl = json['yelpImageUrl'],
        hidden = json['hidden'];

  /// Google specific deserializer from Places API json response
  Gym.fromGoogleJson(Map<String, dynamic> json)
      : id = '',
        yelpId = '',
        yelpRating = null,
        yelpReviewCount = null,
        yelpUrl = null,
        routes = [],
        googleId = json['place_id'],
        name = json['name'],
        hidden = json['hidden'],
        yelpImageUrl = null,
        coordinates = Coordinates(json['geometry']['location']['lat'],
            json['geometry']['location']['lng']),
        this.city = json.containsKey('city')
            ? json['city']
            : _getCityFromVicinity(json['vicinity']),
        this.rating = (json['rating'] is int || json['rating'] is double)
            ? json['rating'].toDouble()
            : null,
        this.ratingsCount = (json['user_ratings_total'] is int)
            ? json['user_ratings_total']
            : null {
    if (json['photos'] is List)
      for (final photo in json['photos'])
        this.googlePhotos.add(PlacesPhoto.fromJson(photo));
  }

  String getImageUrl({int width}) {
    if (googlePhotos.length > 0) {
      return googlePhotos[0].getUrl(width: width);
    } else {
      return yelpImageUrl;
    }
  }

  bool isYelpRating() {
    return yelpRating != null;
  }

  /// Generic serializer
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> googlePhotosMap = [];
    for (final PlacesPhoto photo in googlePhotos)
      googlePhotosMap.add(photo.toJson());
    return {
      'id': id,
      'place_id': googleId,
      'name': name,
      'user_ratings_total': ratingsCount,
      'rating': rating,
      'city': city,
      'hidden': hidden,
      'lng': coordinates.longitude,
      'lat': coordinates.latitude,
      'google_photos': googlePhotosMap
    };
  }
}
