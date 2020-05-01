import 'dart:convert';
import 'package:climbing/models/gym_class.dart';
import 'package:test/test.dart';

void main() {
  test(
      "Gym instance can be created from json string and converted back to json",
      () {
    String jsonString = '''
    {
         "geometry" : {
            "location" : {
               "lat" : 43.6657479,
               "lng" : -79.34251189999999
            },
            "viewport" : {
               "northeast" : {
                  "lat" : 43.66714967989272,
                  "lng" : -79.34092367010726
               },
               "southwest" : {
                  "lat" : 43.66445002010727,
                  "lng" : -79.34362332989271
               }
            }
         },
         "icon" : "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png",
         "id" : "091972eabb865cf400d29dfaeaf3cbe17ec8e3ba",
         "name" : "The Rock Oasis Inc.",
         "opening_hours" : {
            "open_now" : false
         },
         "photos" : [
            {
               "height" : 2340,
               "html_attributions" : [
                  "\u003ca href=\\"https://maps.google.com/maps/contrib/114682195861475231254/photos\\"\u003eThomson Hawks\u003c/a\u003e"
               ],
               "photo_reference" : "CmRaAAAAbC7IAnGLT8CnOkCGFgVE_bxw87Bc3oIy5OMMYFLzLW3Te5md-hTQrUHhnYfCgcb0VaJkDUCX8JcBxsbSDbiRzJIJLsKVztNHIdB5b-W9gjPm2yQPse7Zo-EhEgIKKzgyEhCaRVgK5gYrU42DSwWDfUf5GhRxncOJP8lb9BKFknXbJwjWV7kPlQ",
               "width" : 4160
            }
         ],
         "place_id" : "ChIJC5QtSXrL1IkRhhF0XF6XwBs",
         "plus_code" : {
            "compound_code" : "MM84+7X Toronto, Ontario, Canada",
            "global_code" : "87M2MM84+7X"
         },
         "rating" : 4.6,
         "reference" : "ChIJC5QtSXrL1IkRhhF0XF6XwBs",
         "scope" : "GOOGLE",
         "types" : [ "point_of_interest", "establishment" ],
         "user_ratings_total" : 484,
         "vicinity" : "388 Carlaw Ave Suite 204, Toronto"
      }
    ''';
    Gym gym = Gym.fromGoogleJson(json.decode(jsonString));
    expect(gym.id, '');
    expect(gym.googleId, 'ChIJC5QtSXrL1IkRhhF0XF6XwBs');
    expect(gym.city, 'Toronto');
    expect(gym.name, 'The Rock Oasis Inc.');
    expect(gym.ratingsCount, 484);
    expect(gym.rating, 4.6);
    expect(gym.googlePhotos.length, 1);
    expect(gym.getImageUrl(width: 400),
        'https://maps.googleapis.com/maps/api/place/photo?key=ChIJC5QtSXrL1IkRhhF0XF6XwBs&photoreference=CmRaAAAAbC7IAnGLT8CnOkCGFgVE_bxw87Bc3oIy5OMMYFLzLW3Te5md-hTQrUHhnYfCgcb0VaJkDUCX8JcBxsbSDbiRzJIJLsKVztNHIdB5b-W9gjPm2yQPse7Zo-EhEgIKKzgyEhCaRVgK5gYrU42DSwWDfUf5GhRxncOJP8lb9BKFknXbJwjWV7kPlQ&maxwidth=400');
    Map<String, dynamic> map = gym.toJson();
    expect(map, {
      "id": "",
      "place_id": "ChIJC5QtSXrL1IkRhhF0XF6XwBs",
      "name": "The Rock Oasis Inc.",
      "user_ratings_total": 484,
      "rating": 4.6,
      "city": "Toronto",
      "google_photos": [
        {
          "photo_reference":
              "CmRaAAAAbC7IAnGLT8CnOkCGFgVE_bxw87Bc3oIy5OMMYFLzLW3Te5md-hTQrUHhnYfCgcb0VaJkDUCX8JcBxsbSDbiRzJIJLsKVztNHIdB5b-W9gjPm2yQPse7Zo-EhEgIKKzgyEhCaRVgK5gYrU42DSwWDfUf5GhRxncOJP8lb9BKFknXbJwjWV7kPlQ"
        }
      ]
    });
    gym = Gym.fromGoogleJson(json.decode(json.encode(map)));
    expect(gym.googleId, 'ChIJC5QtSXrL1IkRhhF0XF6XwBs');
    expect(gym.city, 'Toronto');
    expect(gym.name, 'The Rock Oasis Inc.');
    expect(gym.ratingsCount, 484);
    expect(gym.rating, 4.6);
    expect(gym.googlePhotos.length, 0);
    expect(map, {
      "id": "",
      "place_id": "ChIJC5QtSXrL1IkRhhF0XF6XwBs",
      "name": "The Rock Oasis Inc.",
      "user_ratings_total": 484,
      "rating": 4.6,
      "city": "Toronto",
      "google_photos": [
        {
          "photo_reference":
              "CmRaAAAAbC7IAnGLT8CnOkCGFgVE_bxw87Bc3oIy5OMMYFLzLW3Te5md-hTQrUHhnYfCgcb0VaJkDUCX8JcBxsbSDbiRzJIJLsKVztNHIdB5b-W9gjPm2yQPse7Zo-EhEgIKKzgyEhCaRVgK5gYrU42DSwWDfUf5GhRxncOJP8lb9BKFknXbJwjWV7kPlQ"
        }
      ]
    });
  });

}
