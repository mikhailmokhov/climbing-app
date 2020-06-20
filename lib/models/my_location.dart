import 'package:geolocator/geolocator.dart';
import 'coordinates.dart';

///
/// Wrapper for geolocation plugin specific code
abstract class MyLocation {
  static Future<Coordinates> getCoordinates() async {
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    return Coordinates(position.latitude, position.longitude);
  }

  static Future<bool> isAvailable() async {
    final GeolocationStatus status =
        await Geolocator().checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.denied ||
        status == GeolocationStatus.disabled) {
      return false;
    }
    return true;
  }
}
