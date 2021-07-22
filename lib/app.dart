import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/repositories/user_repository.dart';
import 'package:climbing/screens/edit_profile_screen.dart';
import 'package:climbing/screens/gym_screen.dart';
import 'package:climbing/screens/gyms_screen.dart';
import 'package:climbing/services/connectivity_service.dart';
import 'package:climbing/services/haptic_feedback_service.dart';
import 'package:climbing/services/location_service.dart';
import 'package:climbing/services/sign_in_service_abstract.dart';
import 'package:climbing/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vibrate/vibrate.dart';

import 'api/api.dart' as api;
import 'enums/sign_in_provider_enum.dart';
import 'models/app_state.dart';
import 'models/coordinates.dart';
import 'models/gym.dart';
import 'models/user_authority.dart';

class ClimbingApp extends StatefulWidget {
  const ClimbingApp(
      {@required this.userRepository,
      @required this.appleSignInService,
      @required this.connectivityService,
      @required this.locationService,
      this.hapticFeedbackService});

  final UserRepository userRepository;
  final SignInService appleSignInService;
  final HapticFeedbackService hapticFeedbackService;
  final ConnectivityService connectivityService;
  final LocationService locationService;

  @override
  State<StatefulWidget> createState() {
    return ClimbingAppState();
  }
}

class ClimbingAppState extends State<ClimbingApp> with WidgetsBindingObserver {
  AppState appState = AppState();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState = $state');
    if (!appState.locationServiceEnabled &&
        state == AppLifecycleState.resumed) {
      _getLocation();
    }
  }

  /// Check location service, request permissions if necessary, get location.
  Future<void> _getLocation() async {
    // IS LOCATION ENABLED
    bool _enabled = true;
    if (!await widget.locationService.isEnabled()) {
      print('widget.locationService.isEnabled() = false');
      if (!await widget.locationService.requestService()) {
        print('widget.locationService.requestService() = false');
        _enabled = false;
      }
    }

    // IS LOCATION PERMITTED
    bool _permitted = true;
    if (!await widget.locationService.hasPermission()) {
      print('widget.locationService.hasPermission() = false');
      if (!await widget.locationService.requestPermission()) {
        print('widget.locationService.requestPermission() = false');
        _permitted = false;
      }
    }

    // GET LOCATION
    Coordinates _coordinates;
    if (_enabled && _permitted) {
      _coordinates = await widget.locationService.getLocation();
    }

    setState(() {
      appState.locationServiceEnabled = _enabled;
      appState.locationServicePermitted = _permitted;
      appState.coordinates = _coordinates ?? appState.coordinates;
    });
  }

  void updateCoordinates(Coordinates coordinates) {
    setState(() {
      appState.coordinates = coordinates;
    });
  }

  Future<void> fetchGyms({bool force}) async {
    if ((appState.fetchGymsNeeded || force == true) &&
        (appState.isLoading == null || !appState.isLoading) &&
        appState.coordinates != null &&
        appState.isConnected) {
      setState(() {
        appState.isLoading = true;
      });
      final List<Gym> gyms = await api.getGyms(appState.coordinates);
      setState(() {
        appState.gyms = gyms;
        appState.isLoading = false;
        appState.fetchGymsNeeded = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getLocation();

    // Check if connected to the Internet
    widget.connectivityService.isConnected().then((bool isConnected) {
      setState(() {
        appState.isConnected = isConnected;
      });
    });

    // Subscribe to connection changes
    widget.connectivityService.connectionChanged((bool isConnected) {
      setState(() {
        appState.isConnected = isConnected;
      });
    });

    // Load user from local storage
    widget.userRepository.loadUser().then((User user) {
      if (user.appleIdCredentialUser != null) {
        widget.appleSignInService.isSignedIn(user).then((bool signedIn) {
          setState(() {
            appState.user = user;
          });
          api.token = user.token;
        });
      }
    });

    // Check Apple sign in availability and update signInProviderSet which makes
    // Sign in with Apple button visible
    widget.appleSignInService.isAvailable().then((bool available) {
      if (available) {
        setState(() {
          appState.signInProviderSet.add(SignInProvider.APPLE);
        });
      }
    });

    // Add a callback when credentials are revoked
    widget.appleSignInService.credentialsRevoked(() {
      setState(() {
        appState.user = null;
      });
      widget.userRepository.clearUser();
    });

    WidgetsBinding.instance
      ..addPostFrameCallback((_) {
        print('addPostFrameCallback');
      })
      ..addObserver(this); // didChangeAppLifecycleState
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.connectivityService.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    fetchGyms();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          S.delegate,
          // You need to add them if you are using the material library.
          // The material components uses this delegates to provide default
          // localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        themeMode: ThemeMode.system,
        darkTheme: darkThemeData,
        theme: lightThemeData,
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == EditProfileScreen.routeName) {
            return MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => EditProfileScreen(
                    appState: appState,
                    updateUser: updateUser,
                    feedback: feedback),
                fullscreenDialog: true);
          }
          return null;
        },
        initialRoute: GymsScreen.routeName,
        routes: <String, Widget Function(BuildContext)>{
          GymsScreen.routeName: (BuildContext context) {
            return GymsScreen(
              appState: appState,
              signIn: signIn,
              signOut: signOut,
              updateUser: updateUser,
              feedback: feedback,
              updateCoordinates: updateCoordinates,
              fetchGyms: fetchGyms,
            );
          },
          GymScreen.routeName: (BuildContext context) {
            return GymScreen(
                appState: appState,
                updateUser: updateUser,
                signIn: signIn,
                updateGym: updateGym,
                feedback: feedback);
          },
        });
  }

  void feedback(FeedbackType type) {
    widget.hapticFeedbackService?.feedback(type);
  }

  void signOut() {
    widget.userRepository.clearUser();
    api.logout();
    setState(() {
      appState.user = null;
    });
  }

  void updateGym(Gym gym, {String id, bool visible}) {
    setState(() {
      gym.id = id ?? gym.id;
      gym.visible = visible ?? gym.visible;
    });
  }

  void updateUser(
      {String token,
      String googleId,
      String name,
      String email,
      String nickname,
      String pictureId,
      String photoPath,
      String appleIdCredentialUser,
      List<UserAuthority> authorities,
      Set<String> bookmarks}) {
    setState(() {
      appState.user.token = token ?? appState.user.token;
      appState.user.googleId = googleId ?? appState.user.googleId;
      appState.user.name = name ?? appState.user.name;
      appState.user.email = email ?? appState.user.email;
      appState.user.nickname = nickname ?? appState.user.nickname;
      appState.user.pictureId = pictureId ?? appState.user.pictureId;
      appState.user.photoPath = photoPath ?? appState.user.photoPath;
      appState.user.appleIdCredentialUser =
          appleIdCredentialUser ?? appState.user.appleIdCredentialUser;
      appState.user.authorities = authorities ?? appState.user.authorities;
      appState.user.bookmarks = bookmarks ?? appState.user.bookmarks;
    });
  }

  Future<bool> signIn(SignInProvider signInProvider) async {
    switch (signInProvider) {
      case SignInProvider.APPLE: // APPLE SIGN IN
        final User user = await widget.appleSignInService.signIn();
        if (user != null) {
          setState(() {
            appState.user = user;
          });
          widget.userRepository.saveUser(user);
          return true;
        }
        break;
      case SignInProvider.GOOGLE: // GOOGLE SIGN IN
        throw Exception('Google sign in not supported');
    }
    return false;
  }
}
