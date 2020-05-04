// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appTitle {
    return Intl.message(
      'Climbing App',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  String get drawerMenuClearCache {
    return Intl.message(
      'Clear cache',
      name: 'drawerMenuClearCache',
      desc: '',
      args: [],
    );
  }

  String get gymsListTitle {
    return Intl.message(
      'Gyms',
      name: 'gymsListTitle',
      desc: '',
      args: [],
    );
  }

  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  String get signInSignUp {
    return Intl.message(
      'Sign In / Sign Up',
      name: 'signInSignUp',
      desc: '',
      args: [],
    );
  }

  String get signInGoogle {
    return Intl.message(
      'Google Sign In',
      name: 'signInGoogle',
      desc: '',
      args: [],
    );
  }

  String get signInApple {
    return Intl.message(
      'Apple Sign In',
      name: 'signInApple',
      desc: '',
      args: [],
    );
  }

  String get continueWithGoogle {
    return Intl.message(
      'Continue With Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  String get continueWithApple {
    return Intl.message(
      'Continue With Apple',
      name: 'continueWithApple',
      desc: '',
      args: [],
    );
  }

  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  String get routes {
    return Intl.message(
      'Routes',
      name: 'routes',
      desc: '',
      args: [],
    );
  }

  String get addRoute {
    return Intl.message(
      'Add Route',
      name: 'addRoute',
      desc: '',
      args: [],
    );
  }

  String get addNewRoute {
    return Intl.message(
      'Add new route',
      name: 'addNewRoute',
      desc: '',
      args: [],
    );
  }

  String get newRoute {
    return Intl.message(
      'New Route',
      name: 'newRoute',
      desc: '',
      args: [],
    );
  }

  String get difficulty {
    return Intl.message(
      'Difficulty',
      name: 'difficulty',
      desc: '',
      args: [],
    );
  }

  String get newestFirst {
    return Intl.message(
      'Newest First',
      name: 'newestFirst',
      desc: '',
      args: [],
    );
  }

  String get sortRoutes {
    return Intl.message(
      'Sort Routes',
      name: 'sortRoutes',
      desc: '',
      args: [],
    );
  }

  String get grades {
    return Intl.message(
      'Grades',
      name: 'grades',
      desc: '',
      args: [],
    );
  }

  String get chooseGrade {
    return Intl.message(
      'Choose grade',
      name: 'chooseGrade',
      desc: '',
      args: [],
    );
  }

  String get gradingSystem {
    return Intl.message(
      'Grading System',
      name: 'gradingSystem',
      desc: '',
      args: [],
    );
  }

  String get browseGyms {
    return Intl.message(
      'Browse Gyms',
      name: 'browseGyms',
      desc: '',
      args: [],
    );
  }

  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  String get nickname {
    return Intl.message(
      'Nickname',
      name: 'nickname',
      desc: '',
      args: [],
    );
  }

  String get usernameCanNotBeEmpty {
    return Intl.message(
      'Can\'t be empty',
      name: 'usernameCanNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  String get usernameCanNotContainSpaces {
    return Intl.message(
      'Can\'t contain spaces',
      name: 'usernameCanNotContainSpaces',
      desc: '',
      args: [],
    );
  }

  String get SAVE {
    return Intl.message(
      'SAVE',
      name: 'SAVE',
      desc: '',
      args: [],
    );
  }

  String get mapView {
    return Intl.message(
      'Map view',
      name: 'mapView',
      desc: '',
      args: [],
    );
  }

  String get listView {
    return Intl.message(
      'List view',
      name: 'listView',
      desc: '',
      args: [],
    );
  }

  String get requestError {
    return Intl.message(
      'Request Error',
      name: 'requestError',
      desc: '',
      args: [],
    );
  }

  String get RETRY {
    return Intl.message(
      'RETRY',
      name: 'RETRY',
      desc: '',
      args: [],
    );
  }

  String get searchThisArea {
    return Intl.message(
      'Search this area',
      name: 'searchThisArea',
      desc: '',
      args: [],
    );
  }

  String get YES {
    return Intl.message(
      'YES',
      name: 'YES',
      desc: '',
      args: [],
    );
  }

  String get NO {
    return Intl.message(
      'NO',
      name: 'NO',
      desc: '',
      args: [],
    );
  }

  String get signOutQuestion {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'signOutQuestion',
      desc: '',
      args: [],
    );
  }

  String get yosemite {
    return Intl.message(
      'Yosemite',
      name: 'yosemite',
      desc: '',
      args: [],
    );
  }

  String get french {
    return Intl.message(
      'French',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  String get uiaa {
    return Intl.message(
      'UIAA',
      name: 'uiaa',
      desc: '',
      args: [],
    );
  }

  String get uk {
    return Intl.message(
      'UK',
      name: 'uk',
      desc: '',
      args: [],
    );
  }

  String get australian {
    return Intl.message(
      'Australian',
      name: 'australian',
      desc: '',
      args: [],
    );
  }

  String get byContinuingYouAcceptOurPolicies {
    return Intl.message(
      'By continuing you accept our Terms of Use and Privacy Policy.',
      name: 'byContinuingYouAcceptOurPolicies',
      desc: '',
      args: [],
    );
  }

  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  String get near {
    return Intl.message(
      'Near',
      name: 'near',
      desc: '',
      args: [],
    );
  }

  String get didntFindYourGym {
    return Intl.message(
      'Didn\'t find your gym?',
      name: 'didntFindYourGym',
      desc: '',
      args: [],
    );
  }

  String get addItToYelp {
    return Intl.message(
      'Add it to Yelp',
      name: 'addItToYelp',
      desc: '',
      args: [],
    );
  }

  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  String get turnOnLocation {
    return Intl.message(
      'You must turn on Location service to allow search climbing gyms nearby.',
      name: 'turnOnLocation',
      desc: '',
      args: [],
    );
  }

  String get locationServiceIsDisabled {
    return Intl.message(
      'Location service is disabled.',
      name: 'locationServiceIsDisabled',
      desc: '',
      args: [],
    );
  }

  String get locationIsDisabled {
    return Intl.message(
      'Location is disabled',
      name: 'locationIsDisabled',
      desc: '',
      args: [],
    );
  }

  String get enableLocationService {
    return Intl.message(
      'You must enable Location service.',
      name: 'enableLocationService',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'CANCEL',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get openSettings {
    return Intl.message(
      'OPEN SETTINGS',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  String get noGymsFound {
    return Intl.message(
      'No climbing gyms found nearby',
      name: 'noGymsFound',
      desc: '',
      args: [],
    );
  }

  String get saving {
    return Intl.message(
      'Saving',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  String get cropper {
    return Intl.message(
      'Cropper',
      name: 'cropper',
      desc: '',
      args: [],
    );
  }

  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  String get hideBusiness {
    return Intl.message(
      'Hide Business',
      name: 'hideBusiness',
      desc: '',
      args: [],
    );
  }

  String get unhideBusiness {
    return Intl.message(
      'Unhide business',
      name: 'unhideBusiness',
      desc: '',
      args: [],
    );
  }

  String get addToHomeGyms {
    return Intl.message(
      'Add to Home Gyms',
      name: 'addToHomeGyms',
      desc: '',
      args: [],
    );
  }

  String get moreActions {
    return Intl.message(
      'More actions',
      name: 'moreActions',
      desc: '',
      args: [],
    );
  }

  String get purgeCurrentCoordinatesCache {
    return Intl.message(
      'Purge current coordinates Yelp cache',
      name: 'purgeCurrentCoordinatesCache',
      desc: '',
      args: [],
    );
  }

  String get purgeAllCache {
    return Intl.message(
      'Purge all Yelp cache',
      name: 'purgeAllCache',
      desc: '',
      args: [],
    );
  }

  String get hideBusinessQuestion {
    return Intl.message(
      'Are you sure you want to hide this business?',
      name: 'hideBusinessQuestion',
      desc: '',
      args: [],
    );
  }

  String get unhideBusinessQuestion {
    return Intl.message(
      'Are you sure you want to unhide this business?',
      name: 'unhideBusinessQuestion',
      desc: '',
      args: [],
    );
  }

  String get allGyms {
    return Intl.message(
      'All Gyms',
      name: 'allGyms',
      desc: '',
      args: [],
    );
  }

  String get hiddenGyms {
    return Intl.message(
      'Hidden Gyms',
      name: 'hiddenGyms',
      desc: '',
      args: [],
    );
  }

  String get editPhoto {
    return Intl.message(
      'Edit Photo',
      name: 'editPhoto',
      desc: '',
      args: [],
    );
  }

  String get openYelpPage {
    return Intl.message(
      'Open Yelp page',
      name: 'openYelpPage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}