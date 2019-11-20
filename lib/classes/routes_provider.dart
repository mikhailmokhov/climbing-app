import 'dart:convert';
import 'package:climbing/classes/climbing_route_class.dart';
import 'package:http/http.dart' as http;

const API_ENDPOINT = 'http://159.89.121.87:3000/api';

class RoutesProvider {

  static Future<List<ClimbingRoute>> getRoutes(String gymId) async {
    String url = API_ENDPOINT + '/routes/'  + gymId;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<ClimbingRoute> routes = [];
      List<dynamic> routesList = json.decode(response.body);
      routesList.forEach((routeMap){
        routes.add(ClimbingRoute.fromJson(routeMap));
      });
      return routes;
    } else {
      throw 'Request error';
    }
  }

}