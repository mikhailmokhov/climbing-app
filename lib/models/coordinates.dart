import 'package:flutter/cupertino.dart';

/// Describes simple location data
@immutable
class Coordinates {
  const Coordinates(this.latitude, this.longitude);

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(json['latitude'] as double, json['longitude'] as double);
  }

  final double latitude;
  final double longitude;

  Map<String, double> toMap() {
    return <String, double>{'latitude': latitude, 'longitude': longitude};
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinates &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  String toString() {
    return 'Coordinates(latitude:$latitude, longitude:$longitude)';
  }
}
