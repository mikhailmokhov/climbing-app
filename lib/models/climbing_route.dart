///
/// Describes properties and serialization methods of gym instance
class ClimbingRoute {
  ClimbingRoute.fromJson(Map<String, String> json)
      : id = json['route_id'],
        name = json['route_name'];

  final String id;
  String name = '';
  double rating = 0.0;
}
