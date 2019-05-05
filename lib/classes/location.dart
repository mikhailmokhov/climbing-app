///
/// Wrapper for geolocation plugin specific code
abstract class Location {
  static Future<Coordinates> getCoordinates() async {
    //TODO: add code for fetching gps data
    return Coordinates(43.640454, -79.380488);
  }
}

/// Describes simple location data
class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude);
}
