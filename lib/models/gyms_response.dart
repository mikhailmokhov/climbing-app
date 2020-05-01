import 'gym_class.dart';

class GymsResponse {
  List<Gym> businesses = [];
  GymsProvider provider;
  bool cached;

  GymsResponse(this.businesses, this.provider);

  GymsResponse.fromResponse(Map json) {
    assert(json is Map);
    assert(json.containsKey('provider'));
    assert(json.containsKey('businesses'));
    assert(json.containsKey('cached'));
    cached = json['cached'];
    switch (json['provider']) {
      case "YELP":
        provider = GymsProvider.YELP;
        json['businesses'].forEach((businessMap) {
          businesses.add(Gym.fromYelpMap(businessMap));
        });
        break;
      case "GOOGLE":
        provider = GymsProvider.GOOGLE;
        json['businesses'].forEach((businessMap) {
          businesses.add(Gym.fromGoogleJson(businessMap));
        });
        break;
    }
  }
}

enum GymsProvider { YELP, GOOGLE, INTERNAL }
