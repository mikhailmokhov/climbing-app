///
/// Describes properties and serialization methods of gym instance
class Gym {
  final String id;
  final String name;
  final String city;

  /// Google specific fields
  final String googlePlaceId;
  final List<GooglePhoto> googlePhotos = [];
  final double googleRating;
  final int googleUserRatingsTotal;

  /// Google specific method
  static String _getCityFromVicinity(String vicinity) {
    List<String> list = vicinity.split(',');
    if (list.length > 1) {
      return list.last.trim();
    } else {
      return vicinity;
    }
  }

  /// Google specific deserializer from Places API json response
  Gym.fromGoogleJson(Map<String, dynamic> json)
      : this.id = '',
        this.googlePlaceId = json['place_id'],
        this.name = json['name'],
        this.city = json.containsKey('city')
            ? json['city']
            : _getCityFromVicinity(json['vicinity']),
        this.googleRating = (json['rating'] is int || json['rating'] is double)
            ? json['rating'].toDouble()
            : null,
        this.googleUserRatingsTotal = (json['user_ratings_total'] is int)
            ? json['user_ratings_total']
            : null {
    if (json['photos'] is List)
      for (final photo in json['photos'])
        this.googlePhotos.add(GooglePhoto.fromJson(photo));
  }

  /// Google specific method for obtaining Places Photos URL
  String getGooglePhotoUrl(String appKey, {int width}) {
    if (this.googlePhotos.length > 0) {
      return this.googlePhotos[0].getUrl(appKey, width: width);
    } else {
      return '';
    }
  }

  /// Generic serializer
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> googlePhotos = [];
    for (final photo in this.googlePhotos) googlePhotos.add(photo.toJson());
    return {
      'id': this.id,
      'place_id': this.googlePlaceId,
      'name': this.name,
      'user_ratings_total': this.googleUserRatingsTotal,
      'rating': this.googleRating,
      'city': this.city,
      'google_photos': googlePhotos
    };
  }
}

/// Describes Google Place API photo instance
class GooglePhoto {
  final String reference;

  GooglePhoto.fromJson(Map<String, dynamic> json)
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

/// Gyms provider
/// Can not be instantiated
class Gyms {
  static final List<Gym> _list = [];

  static int get length => _list.length;

  Gym operator [](int index) => _list[index];

  void operator []=(int index, Gym value) {
    _list[index] = value;
  }

  static void add(Gym value) => _list.add(value);

  Gyms.fromGoogleJson(List<dynamic> list) {
    for (final gym in list) _list.add(Gym.fromGoogleJson(gym));
  }

  static toJson() {
    List<Map<String, dynamic>> gyms = [];
    for (final gym in _list) gyms.add(gym.toJson());
    return {"gyms": gyms};
  }
}
