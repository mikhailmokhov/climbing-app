// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Routesetter`
  String get appTitle {
    return Intl.message(
      'Routesetter',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Clear cache`
  String get drawerMenuClearCache {
    return Intl.message(
      'Clear cache',
      name: 'drawerMenuClearCache',
      desc: '',
      args: [],
    );
  }

  /// `Gyms`
  String get gymsListTitle {
    return Intl.message(
      'Gyms',
      name: 'gymsListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Sign In / Sign Up`
  String get signInSignUp {
    return Intl.message(
      'Sign In / Sign Up',
      name: 'signInSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Google Sign In`
  String get signInGoogle {
    return Intl.message(
      'Google Sign In',
      name: 'signInGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Apple Sign In`
  String get signInApple {
    return Intl.message(
      'Apple Sign In',
      name: 'signInApple',
      desc: '',
      args: [],
    );
  }

  /// `Continue With Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue With Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Continue With Apple`
  String get continueWithApple {
    return Intl.message(
      'Continue With Apple',
      name: 'continueWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Routes`
  String get routes {
    return Intl.message(
      'Routes',
      name: 'routes',
      desc: '',
      args: [],
    );
  }

  /// `Add Route`
  String get addRoute {
    return Intl.message(
      'Add Route',
      name: 'addRoute',
      desc: '',
      args: [],
    );
  }

  /// `Add new route`
  String get addNewRoute {
    return Intl.message(
      'Add new route',
      name: 'addNewRoute',
      desc: '',
      args: [],
    );
  }

  /// `New Route`
  String get newRoute {
    return Intl.message(
      'New Route',
      name: 'newRoute',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty`
  String get difficulty {
    return Intl.message(
      'Difficulty',
      name: 'difficulty',
      desc: '',
      args: [],
    );
  }

  /// `Newest First`
  String get newestFirst {
    return Intl.message(
      'Newest First',
      name: 'newestFirst',
      desc: '',
      args: [],
    );
  }

  /// `Sort Routes`
  String get sortRoutes {
    return Intl.message(
      'Sort Routes',
      name: 'sortRoutes',
      desc: '',
      args: [],
    );
  }

  /// `Grades`
  String get grades {
    return Intl.message(
      'Grades',
      name: 'grades',
      desc: '',
      args: [],
    );
  }

  /// `Choose grade`
  String get chooseGrade {
    return Intl.message(
      'Choose grade',
      name: 'chooseGrade',
      desc: '',
      args: [],
    );
  }

  /// `Grading System`
  String get gradingSystem {
    return Intl.message(
      'Grading System',
      name: 'gradingSystem',
      desc: '',
      args: [],
    );
  }

  /// `Browse Gyms`
  String get browseGyms {
    return Intl.message(
      'Browse Gyms',
      name: 'browseGyms',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get nickname {
    return Intl.message(
      'Nickname',
      name: 'nickname',
      desc: '',
      args: [],
    );
  }

  /// `Can't be empty`
  String get usernameCanNotBeEmpty {
    return Intl.message(
      'Can\'t be empty',
      name: 'usernameCanNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Can't contain spaces`
  String get usernameCanNotContainSpaces {
    return Intl.message(
      'Can\'t contain spaces',
      name: 'usernameCanNotContainSpaces',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get SAVE {
    return Intl.message(
      'SAVE',
      name: 'SAVE',
      desc: '',
      args: [],
    );
  }

  /// `Map view`
  String get mapView {
    return Intl.message(
      'Map view',
      name: 'mapView',
      desc: '',
      args: [],
    );
  }

  /// `List view`
  String get listView {
    return Intl.message(
      'List view',
      name: 'listView',
      desc: '',
      args: [],
    );
  }

  /// `Request Error`
  String get requestError {
    return Intl.message(
      'Request Error',
      name: 'requestError',
      desc: '',
      args: [],
    );
  }

  /// `RETRY`
  String get RETRY {
    return Intl.message(
      'RETRY',
      name: 'RETRY',
      desc: '',
      args: [],
    );
  }

  /// `Search this area`
  String get searchThisArea {
    return Intl.message(
      'Search this area',
      name: 'searchThisArea',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get YES {
    return Intl.message(
      'YES',
      name: 'YES',
      desc: '',
      args: [],
    );
  }

  /// `NO`
  String get NO {
    return Intl.message(
      'NO',
      name: 'NO',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to sign out?`
  String get signOutQuestion {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'signOutQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Yosemite`
  String get yosemite {
    return Intl.message(
      'Yosemite',
      name: 'yosemite',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get french {
    return Intl.message(
      'French',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  /// `UIAA`
  String get uiaa {
    return Intl.message(
      'UIAA',
      name: 'uiaa',
      desc: '',
      args: [],
    );
  }

  /// `UK`
  String get uk {
    return Intl.message(
      'UK',
      name: 'uk',
      desc: '',
      args: [],
    );
  }

  /// `Australian`
  String get australian {
    return Intl.message(
      'Australian',
      name: 'australian',
      desc: '',
      args: [],
    );
  }

  /// `By continuing you accept our Terms of Use and Privacy Policy.`
  String get byContinuingYouAcceptOurPolicies {
    return Intl.message(
      'By continuing you accept our Terms of Use and Privacy Policy.',
      name: 'byContinuingYouAcceptOurPolicies',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Near {city}`
  String nearWithCity(Object city) {
    return Intl.message(
      'Near $city',
      name: 'nearWithCity',
      desc: '',
      args: [city],
    );
  }

  /// `Didn't find your gym?`
  String get didntFindYourGym {
    return Intl.message(
      'Didn\'t find your gym?',
      name: 'didntFindYourGym',
      desc: '',
      args: [],
    );
  }

  /// `Add it to Yelp`
  String get addItToYelp {
    return Intl.message(
      'Add it to Yelp',
      name: 'addItToYelp',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get noInternetConnection {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `You must turn on Location service to allow search climbing gyms nearby.`
  String get turnOnLocation {
    return Intl.message(
      'You must turn on Location service to allow search climbing gyms nearby.',
      name: 'turnOnLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location service is disabled.`
  String get locationServiceIsDisabled {
    return Intl.message(
      'Location service is disabled.',
      name: 'locationServiceIsDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location service is not permitted`
  String get locationServiceIsNotPermitted {
    return Intl.message(
      'Location service is not permitted',
      name: 'locationServiceIsNotPermitted',
      desc: '',
      args: [],
    );
  }

  /// `Location is disabled`
  String get locationIsDisabled {
    return Intl.message(
      'Location is disabled',
      name: 'locationIsDisabled',
      desc: '',
      args: [],
    );
  }

  /// `You must enable Location service.`
  String get enableLocationService {
    return Intl.message(
      'You must enable Location service.',
      name: 'enableLocationService',
      desc: '',
      args: [],
    );
  }

  /// `Allow location service`
  String get allowLocationService {
    return Intl.message(
      'Allow location service',
      name: 'allowLocationService',
      desc: '',
      args: [],
    );
  }

  /// `CANCEL`
  String get cancel {
    return Intl.message(
      'CANCEL',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OPEN SETTINGS`
  String get openSettings {
    return Intl.message(
      'OPEN SETTINGS',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `No climbing gyms found nearby`
  String get noGymsFound {
    return Intl.message(
      'No climbing gyms found nearby',
      name: 'noGymsFound',
      desc: '',
      args: [],
    );
  }

  /// `Saving`
  String get saving {
    return Intl.message(
      'Saving',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `Cropper`
  String get cropper {
    return Intl.message(
      'Cropper',
      name: 'cropper',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Hide Business`
  String get hideBusiness {
    return Intl.message(
      'Hide Business',
      name: 'hideBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Unhide business`
  String get unhideBusiness {
    return Intl.message(
      'Unhide business',
      name: 'unhideBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Add to Home Gyms`
  String get addToHomeGyms {
    return Intl.message(
      'Add to Home Gyms',
      name: 'addToHomeGyms',
      desc: '',
      args: [],
    );
  }

  /// `More actions`
  String get moreActions {
    return Intl.message(
      'More actions',
      name: 'moreActions',
      desc: '',
      args: [],
    );
  }

  /// `Purge current coordinates Yelp cache`
  String get purgeCurrentCoordinatesCache {
    return Intl.message(
      'Purge current coordinates Yelp cache',
      name: 'purgeCurrentCoordinatesCache',
      desc: '',
      args: [],
    );
  }

  /// `Purge all Yelp cache`
  String get purgeAllCache {
    return Intl.message(
      'Purge all Yelp cache',
      name: 'purgeAllCache',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to hide this business?`
  String get hideBusinessQuestion {
    return Intl.message(
      'Are you sure you want to hide this business?',
      name: 'hideBusinessQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to unhide this business?`
  String get unhideBusinessQuestion {
    return Intl.message(
      'Are you sure you want to unhide this business?',
      name: 'unhideBusinessQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Edit Photo`
  String get editPhoto {
    return Intl.message(
      'Edit Photo',
      name: 'editPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Open Yelp page`
  String get openYelpPage {
    return Intl.message(
      'Open Yelp page',
      name: 'openYelpPage',
      desc: '',
      args: [],
    );
  }

  /// `Save to bookmarks`
  String get saveToBookmarks {
    return Intl.message(
      'Save to bookmarks',
      name: 'saveToBookmarks',
      desc: '',
      args: [],
    );
  }

  /// `You need to be signed in`
  String get youNeedToBeSignedIn {
    return Intl.message(
      'You need to be signed in',
      name: 'youNeedToBeSignedIn',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get list {
    return Intl.message(
      'List',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message(
      'Map',
      name: 'map',
      desc: '',
      args: [],
    );
  }

  /// `Visible Gyms ({count})`
  String showVisibleGyms(Object count) {
    return Intl.message(
      'Visible Gyms ($count)',
      name: 'showVisibleGyms',
      desc: '',
      args: [count],
    );
  }

  /// `Hidden Gyms ({count})`
  String showHiddenGyms(Object count) {
    return Intl.message(
      'Hidden Gyms ($count)',
      name: 'showHiddenGyms',
      desc: '',
      args: [count],
    );
  }

  /// `All Gyms ({count})`
  String showAllGyms(Object count) {
    return Intl.message(
      'All Gyms ($count)',
      name: 'showAllGyms',
      desc: '',
      args: [count],
    );
  }

  /// `Hidden ({count})`
  String hiddenWithCount(Object count) {
    return Intl.message(
      'Hidden ($count)',
      name: 'hiddenWithCount',
      desc: '',
      args: [count],
    );
  }

  /// `Visible ({count})`
  String visibleWithCount(Object count) {
    return Intl.message(
      'Visible ($count)',
      name: 'visibleWithCount',
      desc: '',
      args: [count],
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
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}