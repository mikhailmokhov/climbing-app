import 'dart:convert';
import 'package:climbing/classes/gym.dart';
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
        expect(gym.googlePlaceId, 'ChIJC5QtSXrL1IkRhhF0XF6XwBs');
        expect(gym.city, 'Toronto');
        expect(gym.name, 'The Rock Oasis Inc.');
        expect(gym.googleUserRatingsTotal, 484);
        expect(gym.googleRating, 4.6);
        expect(gym.googlePhotos.length, 1);
        expect(gym.getGooglePhotoUrl('ChIJC5QtSXrL1IkRhhF0XF6XwBs', width: 400),
            'https://maps.googleapis.com/maps/api/place/photo?key=ChIJC5QtSXrL1IkRhhF0XF6XwBs&photoreference=CmRaAAAAbC7IAnGLT8CnOkCGFgVE_bxw87Bc3oIy5OMMYFLzLW3Te5md-hTQrUHhnYfCgcb0VaJkDUCX8JcBxsbSDbiRzJIJLsKVztNHIdB5b-W9gjPm2yQPse7Zo-EhEgIKKzgyEhCaRVgK5gYrU42DSwWDfUf5GhRxncOJP8lb9BKFknXbJwjWV7kPlQ&maxwidth=400');
        Map<String, dynamic> map = gym.toJson();
        expect(map, {
          "id":"",
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
        expect(gym.googlePlaceId, 'ChIJC5QtSXrL1IkRhhF0XF6XwBs');
        expect(gym.city, 'Toronto');
        expect(gym.name, 'The Rock Oasis Inc.');
        expect(gym.googleUserRatingsTotal, 484);
        expect(gym.googleRating, 4.6);
        expect(gym.googlePhotos.length, 0);
        expect(map, {
          "id":"",
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

  test(
      "Gyms instance can be created from json string and converted back to json",
          () {
        String jsonString = '''
      {
         "html_attributions" : [],
         "results" : [
            {
               "geometry" : {
                  "location" : {
                     "lat" : -33.870775,
                     "lng" : 151.199025
                  }
               },
               "icon" : "http://maps.gstatic.com/mapfiles/place_api/icons/travel_agent-71.png",
               "id" : "21a0b251c9b8392186142c798263e289fe45b4aa",
               "name" : "Rhythmboat Cruises",
               "opening_hours" : {
                  "open_now" : true
               },
               "photos" : [
                  {
                     "height" : 270,
                     "html_attributions" : [],
                     "photo_reference" : "CnRnAAAAF-LjFR1ZV93eawe1cU_3QNMCNmaGkowY7CnOf-kcNmPhNnPEG9W979jOuJJ1sGr75rhD5hqKzjD8vbMbSsRnq_Ni3ZIGfY6hKWmsOf3qHKJInkm4h55lzvLAXJVc-Rr4kI9O1tmIblblUpg2oqoq8RIQRMQJhFsTr5s9haxQ07EQHxoUO0ICubVFGYfJiMUPor1GnIWb5i8",
                     "width" : 519
                  }
               ],
               "place_id" : "ChIJyWEHuEmuEmsRm9hTkapTCrk",
               "scope" : "GOOGLE",
               "reference" : "CoQBdQAAAFSiijw5-cAV68xdf2O18pKIZ0seJh03u9h9wk_lEdG-cP1dWvp_QGS4SNCBMk_fB06YRsfMrNkINtPez22p5lRIlj5ty_HmcNwcl6GZXbD2RdXsVfLYlQwnZQcnu7ihkjZp_2gk1-fWXql3GQ8-1BEGwgCxG-eaSnIJIBPuIpihEhAY1WYdxPvOWsPnb2-nGb6QGhTipN0lgaLpQTnkcMeAIEvCsSa0Ww",
               "types" : [ "travel_agency", "restaurant", "food", "establishment" ],
               "vicinity" : "Pyrmont Bay Wharf Darling Dr, Sydney"
            },
            {
               "geometry" : {
                  "location" : {
                     "lat" : -33.866891,
                     "lng" : 151.200814
                  }
               },
               "icon" : "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
               "id" : "45a27fd8d56c56dc62afc9b49e1d850440d5c403",
               "name" : "Private Charter Sydney Habour Cruise",
               "photos" : [
                  {
                     "height" : 426,
                     "html_attributions" : [],
                     "photo_reference" : "CnRnAAAAL3n0Zu3U6fseyPl8URGKD49aGB2Wka7CKDZfamoGX2ZTLMBYgTUshjr-MXc0_O2BbvlUAZWtQTBHUVZ-5Sxb1-P-VX2Fx0sZF87q-9vUt19VDwQQmAX_mjQe7UWmU5lJGCOXSgxp2fu1b5VR_PF31RIQTKZLfqm8TA1eynnN4M1XShoU8adzJCcOWK0er14h8SqOIDZctvU",
                     "width" : 640
                  }
               ],
               "place_id" : "ChIJqwS6fjiuEmsRJAMiOY9MSms",
               "scope" : "GOOGLE",
               "reference" : "CpQBhgAAAFN27qR_t5oSDKPUzjQIeQa3lrRpFTm5alW3ZYbMFm8k10ETbISfK9S1nwcJVfrP-bjra7NSPuhaRulxoonSPQklDyB-xGvcJncq6qDXIUQ3hlI-bx4AxYckAOX74LkupHq7bcaREgrSBE-U6GbA1C3U7I-HnweO4IPtztSEcgW09y03v1hgHzL8xSDElmkQtRIQzLbyBfj3e0FhJzABXjM2QBoUE2EnL-DzWrzpgmMEulUBLGrtu2Y",
               "types" : [ "restaurant", "food", "establishment" ],
               "vicinity" : "Australia"
            },
            {
               "geometry" : {
                  "location" : {
                     "lat" : -33.870943,
                     "lng" : 151.190311
                  }
               },
               "icon" : "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
               "id" : "30bee58f819b6c47bd24151802f25ecf11df8943",
               "name" : "Bucks Party Cruise",
               "opening_hours" : {
                  "open_now" : true
               },
               "photos" : [
                  {
                     "height" : 600,
                     "html_attributions" : [],
                     "photo_reference" : "CnRnAAAA48AX5MsHIMiuipON_Lgh97hPiYDFkxx_vnaZQMOcvcQwYN92o33t5RwjRpOue5R47AjfMltntoz71hto40zqo7vFyxhDuuqhAChKGRQ5mdO5jv5CKWlzi182PICiOb37PiBtiFt7lSLe1SedoyrD-xIQD8xqSOaejWejYHCN4Ye2XBoUT3q2IXJQpMkmffJiBNftv8QSwF4",
                     "width" : 800
                  }
               ],
               "place_id" : "ChIJLfySpTOuEmsRsc_JfJtljdc",
               "scope" : "GOOGLE",
               "reference" : "CoQBdQAAANQSThnTekt-UokiTiX3oUFT6YDfdQJIG0ljlQnkLfWefcKmjxax0xmUpWjmpWdOsScl9zSyBNImmrTO9AE9DnWTdQ2hY7n-OOU4UgCfX7U0TE1Vf7jyODRISbK-u86TBJij0b2i7oUWq2bGr0cQSj8CV97U5q8SJR3AFDYi3ogqEhCMXjNLR1k8fiXTkG2BxGJmGhTqwE8C4grdjvJ0w5UsAVoOH7v8HQ",
               "types" : [ "restaurant", "food", "establishment" ],
               "vicinity" : "37 Bank St, Pyrmont"
            },
            {
               "geometry" : {
                  "location" : {
                     "lat" : -33.867591,
                     "lng" : 151.201196
                  }
               },
               "icon" : "http://maps.gstatic.com/mapfiles/place_api/icons/travel_agent-71.png",
               "id" : "a97f9fb468bcd26b68a23072a55af82d4b325e0d",
               "name" : "Australian Cruise Group",
               "opening_hours" : {
                  "open_now" : true
               },
               "photos" : [
                  {
                     "height" : 242,
                     "html_attributions" : [],
                     "photo_reference" : "CnRnAAAABjeoPQ7NUU3pDitV4Vs0BgP1FLhf_iCgStUZUr4ZuNqQnc5k43jbvjKC2hTGM8SrmdJYyOyxRO3D2yutoJwVC4Vp_dzckkjG35L6LfMm5sjrOr6uyOtr2PNCp1xQylx6vhdcpW8yZjBZCvVsjNajLBIQ-z4ttAMIc8EjEZV7LsoFgRoU6OrqxvKCnkJGb9F16W57iIV4LuM",
                     "width" : 200
                  }
               ],
               "place_id" : "ChIJrTLr-GyuEmsRBfy61i59si0",
               "scope" : "GOOGLE",
               "reference" : "CoQBeQAAAFvf12y8veSQMdIMmAXQmus1zqkgKQ-O2KEX0Kr47rIRTy6HNsyosVl0CjvEBulIu_cujrSOgICdcxNioFDHtAxXBhqeR-8xXtm52Bp0lVwnO3LzLFY3jeo8WrsyIwNE1kQlGuWA4xklpOknHJuRXSQJVheRlYijOHSgsBQ35mOcEhC5IpbpqCMe82yR136087wZGhSziPEbooYkHLn9e5njOTuBprcfVw",
               "types" : [ "travel_agency", "restaurant", "food", "establishment" ],
               "vicinity" : "32 The Promenade, King Street Wharf 5, Sydney"
            }
         ],
         "status" : "OK"
       }
      ''';
        Gyms gyms = Gyms.fromGoogleJson(json.decode(jsonString)["results"]);
        expect(gyms[0].googlePlaceId, 'ChIJyWEHuEmuEmsRm9hTkapTCrk');
        expect(gyms[0].city, 'Sydney');
        expect(gyms[0].googleRating, null);
        expect(gyms[0].googleUserRatingsTotal, null);
        expect(gyms[0].name, 'Rhythmboat Cruises');
        expect(gyms[0].googlePhotos.length, 1);
      });
}