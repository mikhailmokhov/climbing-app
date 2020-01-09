
import 'package:geolocator/geolocator.dart';

///
/// Wrapper for geolocation plugin specific code
abstract class MyLocation {
  static Future<Coordinates> getCoordinates() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    return Coordinates(position.latitude, position.longitude);
  }

  static Future<bool> isAvailable() async {
    GeolocationStatus status =
        await Geolocator().checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.denied ||
        status == GeolocationStatus.disabled) {
      return false;
    }
    return true;
  }
}

/// Describes simple location data
class Coordinates {
  double latitude;
  double longitude;

  Coordinates(this.latitude, this.longitude);

  Map<String, double> toMap() {
    return {"latitude": latitude, "longitude": longitude};
  }

  String toString(){
    return latitude.toString() + "," + longitude.toString();
  }
}
