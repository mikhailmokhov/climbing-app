import 'package:climbing/models/coordinates.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> isEnabled() async {
    return await _location.serviceEnabled();
  }

  Future<bool> requestService() async {
    return _location.requestService();
  }

  Future<bool> hasPermission() async {
    return _hasPermission(await _location.hasPermission());
  }

  Future<bool> requestPermission() async {
    return _hasPermission(await _location.requestPermission());
  }

  Future<Coordinates> getLocation() async {
    final LocationData locationData = await _location.getLocation();
    return Coordinates(locationData.latitude, locationData.longitude);
  }

  bool _hasPermission(PermissionStatus permissionStatus) {
    switch (permissionStatus) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.deniedForever:
    }
    return false;
  }
}
