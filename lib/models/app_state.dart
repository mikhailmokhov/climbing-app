import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/models/coordinates.dart';
import 'package:climbing/screens/gyms_screen.dart';
import 'package:flutter/cupertino.dart';

import 'gym.dart';
import 'user.dart';

class AppState {
  AppState();

  final Set<SignInProvider> signInProviderSet = <SignInProvider>{};
  List<Gym> gyms = const <Gym>[];
  bool fetchGymsNeeded = true;
  bool canVibrate;
  User user;
  bool isConnected;
  bool isLoading;
  Coordinates coordinates;
  bool locationServiceEnabled = false;
  bool locationServicePermitted = false;

  List<Gym> filteredGyms(GymsFilter activeFilter) => gyms.where((Gym gym) {
        switch (activeFilter) {
          case GymsFilter.showVisibleGyms:
            return gym.visible;
          case GymsFilter.showHiddenGyms:
            return !gym.visible;
          case GymsFilter.showAllGyms:
          default:
            return true;
        }
      }).toList();
}

enum GymsFilterGymsVisibilityFilter { visible, hidden }
