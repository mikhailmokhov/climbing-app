import 'package:climbing/classes/grade_scale_class.dart';

///
/// Describes properties and serialization methods of gym instance
class ClimbingRoute {
  final String id;
  String name = "";
  GradeScale grade;
  double rating = 0.0;

  ClimbingRoute.fromJson(Map<String, dynamic> json)
      : this.id = json['route_id'],
        this.name = json['route_name']{
    if(json.containsKey('difficulty')){
      this.grade = GradeScale(json['difficulty'].toDouble());
    }
  }

}
