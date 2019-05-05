import 'package:climbing/classes/location.dart';
import 'package:test/test.dart';

void main() {
  test("Location wrapper can be used to obtain gps coordinates", () async {
    Location.getCoordinates().then((Coordinates coordinates) {
      expect(coordinates.latitude is double, true);
      expect(coordinates.longitude is double, true);
    });
  });
}
