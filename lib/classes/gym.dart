class Gym {
  final String placeId;
  final String name;
  final List<GymPhoto> photos = [];
  final String vicinity;
  final String city;
  double rating;
  int userRatingsTotal;

  static String _getCityFromVicinity(String vicinity) {
    List<String> list = vicinity.split(',');
    if (list.length > 1) {
      return list.last.trim();
    } else {
      return vicinity;
    }
  }

  Gym.fromJson(Map<String, dynamic> json)
      : this.placeId = json['place_id'],
        this.name = json['name'],
        this.vicinity = json['vicinity'],
        this.city = json.containsKey('city')
            ? json['city']
            : _getCityFromVicinity(json['vicinity']) {
    if (json['rating'] is int || json['rating'] is double)
      this.rating = json['rating'].toDouble();
    if (json['user_ratings_total'] is int)
      this.userRatingsTotal = json['user_ratings_total'];
    if (json['photos'] is List)
      for (final photo in json['photos'])
        this.photos.add(GymPhoto.fromJson(photo));
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> photos = [];
    for (final photo in this.photos) photos.add(photo.toJson());
    return {
      'place_id': this.placeId,
      'name': this.name,
      'user_ratings_total': this.userRatingsTotal,
      'vicinity': this.vicinity,
      'rating': this.rating,
      'city': this.city,
      'photos': photos
    };
  }

  String getPhotoUrl(String appKey, {int width}) {
    if (this.photos.length > 0) {
      return this.photos[0].getUrl(appKey, width: width);
    } else {
      return '';
    }
  }
}

class GymPhoto {
  final String reference;

  GymPhoto.fromJson(Map<String, dynamic> json)
      : this.reference = json['photo_reference'];

  Map<String, dynamic> toJson() => {'photo_reference': this.reference};

  String getUrl(String appKey, {int width}) {
    width ??= 300;
    return 'https://maps.googleapis.com/maps/api/place/photo?key=' +
        appKey +
        '&photoreference=' +
        this.reference +
        '&maxwidth=' +
        width.toString();
  }
}

class Gyms {
  final List<Gym> _list = [];

  int get length => _list.length;

  Gym operator [](int index) => _list[index];

  void operator []=(int index, Gym value) {
    _list[index] = value;
  }

  void add(Gym value) => _list.add(value);

  void addAll(Iterable<Gym> all) => _list.addAll(all);

  Gyms.fromJson(List<dynamic> list) {
    //TODO: add filter for bad items such as 0 rating
    for (final gym in list) _list.add(Gym.fromJson(gym));
  }

  toJson() {
    List<Map<String, dynamic>> gyms = [];
    for (final gym in _list) gyms.add(gym.toJson());
    return {"gyms": gyms};
  }
}
