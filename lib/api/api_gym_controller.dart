part of 'package:climbing/api/api.dart';

Future<List<Gym>> getGyms(Coordinates coordinates) async {
  final Response<dynamic> response =
      await _dio.get<dynamic>('/gyms', queryParameters: coordinates.toMap());
  final List<Gym> result = <Gym>[];
  if (response.data is List) {
    for (final dynamic gym in response.data as List<dynamic>) {
      if (gym is Map<String, dynamic>) {
        result.add(Gym.fromJson(gym));
      }
    }
  }
  return result;
}

Future<void> setGymVisibility(GymId gymId, bool visibility) async {
  await _dio.patch<void>('/gyms/' + gymId.id,
      queryParameters: <String, dynamic>{
        'provider': EnumToString.convertToString(gymId.provider),
        'visibility': visibility
      },
      options: _generateOptions());
}

Future<void> purgeYelpCacheForCoordinates(Coordinates coordinates) async {
  await _dio.delete<void>('/gyms/cache/yelp',
      queryParameters: <String, double>{
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude
      },
      options: _generateOptions());
}

Future<void> purgeYelpCache() async {
  await _dio.delete<void>('/gyms/cache/yelp', options: _generateOptions());
}
