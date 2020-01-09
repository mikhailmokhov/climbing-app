import 'gym_class.dart';

class GymsResponse {
  List<Gym> gyms = [];
  GymsProvider provider;
  bool cached;

  GymsResponse(this.gyms, this.provider);

  GymsResponse.fromResponse(Map json) {
    assert(json is Map);
    assert(json.containsKey('provider'));
    assert(json.containsKey('gyms'));
    assert(json.containsKey('cached'));
    cached = json['cached'];
    switch (json['provider']) {
      case "YELP":
        provider = GymsProvider.YELP;
        break;
      case "GOOGLE":
        provider = GymsProvider.GOOGLE;
        break;
    }
    json['gyms'].forEach((gymMap) {
      gyms.add(Gym.fromYelpMap(gymMap));
    });
  }
}

enum GymsProvider { YELP, GOOGLE }
