import 'package:geolocator/geolocator.dart';
import 'coordinates.dart';

///
/// Wrapper for geolocation plugin specific code
abstract class MyLocation {
  static Future<Coordinates> getCoordinates() async {
    final Position position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    return Coordinates(position.latitude, position.longitude);
  }

  static Future<bool> isAvailable() async {
    final LocationPermission status =
        await Geolocator.checkPermission();
    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
