import 'package:climbing/enums/gyms_provider.dart';

import 'coordinates.dart';
import 'gym_id.dart';

///
/// Describes properties and serialization methods of gym instance
class Gym {
  Gym(
      // Common
      this.id,
      this._name,
      this.city,
      this.yelpId,
      this.googleId,
      this.visible,
      this.distance,
      this.coordinates,

      // YELP specific fields
      this._yelpName,
      this.yelpImageUrl,
      this.yelpUrl,
      this.yelpRating,
      this.yelpReviewCount,
      this.yelpCoordinates,
      this.yelpCity,
      this.yelpDistance);

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      json['id'] as String,
      json['name'] as String,
      json['city'] == null ? '' : json['city'] as String,
      json['yelpId'] as String,
      json['googleId'] as String,
      json['visible'] as bool ?? true,
      json['distance'] as double,
      json['coordinates'] is Map<String, double>
          ? Coordinates.fromJson(json['coordinates'] as Map<String, double>)
          : null,
      json['yelpName'] as String,
      json['yelpImageUrl'] as String,
      json['yelpUrl'] as String,
      json['yelpRating'] as double,
      json['yelpReviewCount'] as int,
      json['yelpCoordinates'] is Map<String, dynamic>
          ? Coordinates.fromJson(
              json['yelpCoordinates'] as Map<String, dynamic>)
          : null,
      json['yelpCity'] as String,
      json['yelpDistance'] as double,
    );
  }

  /// Common properties
  String id;
  final String _name;
  final String city;
  final String yelpId;
  final String googleId;
  bool visible;
  final double distance;
  final Coordinates coordinates;

  /// YELP specific
  final String _yelpName;
  final String yelpImageUrl;
  final String yelpUrl;
  final double yelpRating;
  final int yelpReviewCount;
  final Coordinates yelpCoordinates;
  final String yelpCity;
  final double yelpDistance;

  String getName() {
    if (_name != null) {
      return _name;
    } else if (_yelpName != null) {
      return _yelpName;
    } else {
      return '';
    }
  }

  String getImageUrl({int width}) {
    return yelpImageUrl;
  }

  @override
  String toString() {
    return 'Gym(id:$id, name:$_name, city:$city, visible:$visible, yelpId:$yelpId)';
  }

  GymId getFirstGymId() {
    if (id != null) {
      return GymId(id, GymProvider.INTERNAL);
    } else if (yelpId != null) {
      return GymId(yelpId, GymProvider.YELP);
    } else {
      throw Exception('Gym does not have an id');
    }
  }
}
