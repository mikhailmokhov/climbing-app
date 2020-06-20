// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(count) => "Hidden (${count})";

  static m1(city) => "Near ${city}";

  static m2(count) => "All Gyms (${count})";

  static m3(count) => "Hidden Gyms (${count})";

  static m4(count) => "Visible Gyms (${count})";

  static m5(count) => "Visible (${count})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "NO" : MessageLookupByLibrary.simpleMessage("NO"),
    "RETRY" : MessageLookupByLibrary.simpleMessage("RETRY"),
    "SAVE" : MessageLookupByLibrary.simpleMessage("SAVE"),
    "YES" : MessageLookupByLibrary.simpleMessage("YES"),
    "addItToYelp" : MessageLookupByLibrary.simpleMessage("Add it to Yelp"),
    "addNewRoute" : MessageLookupByLibrary.simpleMessage("Add new route"),
    "addRoute" : MessageLookupByLibrary.simpleMessage("Add Route"),
    "addToHomeGyms" : MessageLookupByLibrary.simpleMessage("Add to Home Gyms"),
    "allowLocationService" : MessageLookupByLibrary.simpleMessage("Allow location service"),
    "appTitle" : MessageLookupByLibrary.simpleMessage("Routesetter"),
    "australian" : MessageLookupByLibrary.simpleMessage("Australian"),
    "browseGyms" : MessageLookupByLibrary.simpleMessage("Browse Gyms"),
    "byContinuingYouAcceptOurPolicies" : MessageLookupByLibrary.simpleMessage("By continuing you accept our Terms of Use and Privacy Policy."),
    "camera" : MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel" : MessageLookupByLibrary.simpleMessage("CANCEL"),
    "chooseGrade" : MessageLookupByLibrary.simpleMessage("Choose grade"),
    "continueWithApple" : MessageLookupByLibrary.simpleMessage("Continue With Apple"),
    "continueWithGoogle" : MessageLookupByLibrary.simpleMessage("Continue With Google"),
    "cropper" : MessageLookupByLibrary.simpleMessage("Cropper"),
    "didntFindYourGym" : MessageLookupByLibrary.simpleMessage("Didn\'t find your gym?"),
    "difficulty" : MessageLookupByLibrary.simpleMessage("Difficulty"),
    "drawerMenuClearCache" : MessageLookupByLibrary.simpleMessage("Clear cache"),
    "editPhoto" : MessageLookupByLibrary.simpleMessage("Edit Photo"),
    "editProfile" : MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "enableLocationService" : MessageLookupByLibrary.simpleMessage("You must enable Location service."),
    "french" : MessageLookupByLibrary.simpleMessage("French"),
    "fullName" : MessageLookupByLibrary.simpleMessage("Full Name"),
    "gallery" : MessageLookupByLibrary.simpleMessage("Gallery"),
    "grades" : MessageLookupByLibrary.simpleMessage("Grades"),
    "gradingSystem" : MessageLookupByLibrary.simpleMessage("Grading System"),
    "gymsListTitle" : MessageLookupByLibrary.simpleMessage("Gyms"),
    "hiddenWithCount" : m0,
    "hideBusiness" : MessageLookupByLibrary.simpleMessage("Hide Business"),
    "hideBusinessQuestion" : MessageLookupByLibrary.simpleMessage("Are you sure you want to hide this business?"),
    "list" : MessageLookupByLibrary.simpleMessage("List"),
    "listView" : MessageLookupByLibrary.simpleMessage("List view"),
    "locationIsDisabled" : MessageLookupByLibrary.simpleMessage("Location is disabled"),
    "locationServiceIsDisabled" : MessageLookupByLibrary.simpleMessage("Location service is disabled."),
    "locationServiceIsNotPermitted" : MessageLookupByLibrary.simpleMessage("Location service is not permitted"),
    "map" : MessageLookupByLibrary.simpleMessage("Map"),
    "mapView" : MessageLookupByLibrary.simpleMessage("Map view"),
    "menu" : MessageLookupByLibrary.simpleMessage("Menu"),
    "moreActions" : MessageLookupByLibrary.simpleMessage("More actions"),
    "nearWithCity" : m1,
    "newRoute" : MessageLookupByLibrary.simpleMessage("New Route"),
    "newestFirst" : MessageLookupByLibrary.simpleMessage("Newest First"),
    "nickname" : MessageLookupByLibrary.simpleMessage("Nickname"),
    "noGymsFound" : MessageLookupByLibrary.simpleMessage("No climbing gyms found nearby"),
    "noInternetConnection" : MessageLookupByLibrary.simpleMessage("No Internet Connection"),
    "openSettings" : MessageLookupByLibrary.simpleMessage("OPEN SETTINGS"),
    "openYelpPage" : MessageLookupByLibrary.simpleMessage("Open Yelp page"),
    "purgeAllCache" : MessageLookupByLibrary.simpleMessage("Purge all Yelp cache"),
    "purgeCurrentCoordinatesCache" : MessageLookupByLibrary.simpleMessage("Purge current coordinates Yelp cache"),
    "refresh" : MessageLookupByLibrary.simpleMessage("Refresh"),
    "register" : MessageLookupByLibrary.simpleMessage("Register"),
    "requestError" : MessageLookupByLibrary.simpleMessage("Request Error"),
    "reviews" : MessageLookupByLibrary.simpleMessage("Reviews"),
    "routes" : MessageLookupByLibrary.simpleMessage("Routes"),
    "saveToBookmarks" : MessageLookupByLibrary.simpleMessage("Save to bookmarks"),
    "saving" : MessageLookupByLibrary.simpleMessage("Saving"),
    "searchThisArea" : MessageLookupByLibrary.simpleMessage("Search this area"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "showAllGyms" : m2,
    "showHiddenGyms" : m3,
    "showVisibleGyms" : m4,
    "signInApple" : MessageLookupByLibrary.simpleMessage("Apple Sign In"),
    "signInGoogle" : MessageLookupByLibrary.simpleMessage("Google Sign In"),
    "signInSignUp" : MessageLookupByLibrary.simpleMessage("Sign In / Sign Up"),
    "signOut" : MessageLookupByLibrary.simpleMessage("Sign Out"),
    "signOutQuestion" : MessageLookupByLibrary.simpleMessage("Are you sure you want to sign out?"),
    "sortRoutes" : MessageLookupByLibrary.simpleMessage("Sort Routes"),
    "turnOnLocation" : MessageLookupByLibrary.simpleMessage("You must turn on Location service to allow search climbing gyms nearby."),
    "uiaa" : MessageLookupByLibrary.simpleMessage("UIAA"),
    "uk" : MessageLookupByLibrary.simpleMessage("UK"),
    "unhideBusiness" : MessageLookupByLibrary.simpleMessage("Unhide business"),
    "unhideBusinessQuestion" : MessageLookupByLibrary.simpleMessage("Are you sure you want to unhide this business?"),
    "usernameCanNotBeEmpty" : MessageLookupByLibrary.simpleMessage("Can\'t be empty"),
    "usernameCanNotContainSpaces" : MessageLookupByLibrary.simpleMessage("Can\'t contain spaces"),
    "visibleWithCount" : m5,
    "yosemite" : MessageLookupByLibrary.simpleMessage("Yosemite"),
    "youNeedToBeSignedIn" : MessageLookupByLibrary.simpleMessage("You need to be signed in")
  };
}
