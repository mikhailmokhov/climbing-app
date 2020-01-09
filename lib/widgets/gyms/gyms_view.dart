import 'dart:async';

import 'package:climbing/classes/gyms_response.dart';
import 'package:climbing/classes/api.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:climbing/widgets/gyms/gyms_list_empty_response.dart';
import 'package:climbing/widgets/gyms/gyms_map.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:climbing/classes/gym_class.dart';
import 'package:climbing/classes/my_location.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:climbing/widgets/drawer_menu_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:vibrate/vibrate.dart';
import 'package:flushbar/flushbar.dart';
import '../gym_widget.dart';

import 'gyms_list.dart';
import 'disabled_location_utils.dart';

enum ViewMode { list, map }

class GymsView extends StatefulWidget {
  static const String routeName = '/gymslist';
  final User user;
  final Function signOut, signedIn, register, openSettings, editAccount;
  final bool isAppleSignInAvailable, isGoogleSignInAvailable;
  final Api api;
  final Future<bool> canVibrate;

  GymsView({
    @required this.user,
    @required this.signOut,
    @required this.signedIn,
    @required this.register,
    @required this.openSettings,
    @required this.editAccount,
    @required this.api,
    @required this.canVibrate,
    Key key,
    this.isAppleSignInAvailable,
    this.isGoogleSignInAvailable,
  }) : super(key: key);

  @override
  _GymsViewState createState() => _GymsViewState();
}

class _GymsViewState extends State<GymsView> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ViewMode viewMode = ViewMode.list;
  bool locationServiceAvailable = true;
  GeolocationStatus geolocationStatus = GeolocationStatus.unknown;
  ServiceStatus serviceStatus = ServiceStatus.unknown;
  StreamSubscription subscription;
  ConnectivityResult connectivityStatus;

  List<Gym> gyms = [];
  Coordinates coordinates;
  GymsProvider provider;
  Widget widgetToShow;
  Flushbar flushbar;

  gymOnTap(Gym gym, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GymWidget(gym)),
    );
  }

  setCoordinates(Coordinates coordinates) {
    setState(() {
      this.coordinates = coordinates;
    });
  }

  showError(String error) {
    flushbar = Flushbar(
      message: error,
      backgroundColor: Colors.deepOrange,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
    )..show(this.context);
  }

  Future<void> fetchApi(Coordinates coordinates) {
    Completer completer = new Completer();
    Api.gyms(coordinates).then((GymsResponse gymsResponse) {
      setState(() {
        provider = gymsResponse.provider;
        gyms = gymsResponse.gyms;
        completer.complete();
        flushbar?.dismiss();
      });
    }).catchError((error) {
      completer.completeError(error);
    });
    return completer.future;
  }

  Future<void> refreshGyms(BuildContext context) {
    Completer completer = new Completer();
    if (coordinates != null) {
      fetchApi(coordinates).then((_) {
        completer.complete();
      }).catchError((error) {
        completer.completeError(error);
      });
    } else {
      Geolocator()
          .checkGeolocationPermissionStatus()
          .then((GeolocationStatus status) async {
        ServiceStatus serviceStatus =
            await LocationPermissions().checkServiceStatus();
        geolocationStatus = status;
        if (status == GeolocationStatus.granted ||
            status == GeolocationStatus.unknown) {
          setState(() {
            locationServiceAvailable = true;
          });
          MyLocation.getCoordinates().then((Coordinates coordinates) {
            setState(() {
              this.coordinates = coordinates;
            });
            fetchApi(coordinates).then((_) {
              completer.complete();
            }).catchError((error) {
              completer.completeError(error);
            });
          }).catchError((error) {
            completer.completeError(error);
          });
        } else {
          completer.complete();
          setState(() {
            locationServiceAvailable = false;
          });
          // OPEN LOCATION SETTINGS DIALOG
          OpenLocationSettingsDialog.show(
                  context, geolocationStatus, serviceStatus)
              .then((result) {
            if (result) {
              // delay to wait for the dialog to close
              Future.delayed(const Duration(milliseconds: 200), () {
                OpenLocationSettingsDialog.openSettings(status, serviceStatus);
              });
            }
          });
        }
      }).catchError((error) {
        completer.completeError(error);
      });
    }
    return completer.future;
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        connectivityStatus = result;
      });
      if (connectivityStatus == ConnectivityResult.none) {
        showError(S.of(this.context).noInternetConnection);
      } else {
        flushbar.dismiss();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      setState(() {
        connectivityStatus = connectivityResult;
      });
      if (connectivityStatus != ConnectivityResult.none) {
        _refreshIndicatorKey.currentState?.show();
      } else {
        showError(S.of(this.context).noInternetConnection);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!locationServiceAvailable && state == AppLifecycleState.resumed)
      _refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationServiceAvailable) {
      widgetToShow = LocationDisabled(geolocationStatus, serviceStatus);
    } else if (viewMode == ViewMode.list) {
      if (gyms?.length == 0) {
        widgetToShow = EmptyResponse();
      } else {
        widgetToShow = GymsList(refreshGyms, gymOnTap, _refreshIndicatorKey,
            gyms, coordinates, provider);
      }
    } else {
      widgetToShow =
          GymsMap(coordinates, gyms, setCoordinates, _refreshIndicatorKey);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(S.of(context).gymsList_title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: S.of(context).menu,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            viewMode == ViewMode.list
                ? IconButton(
                    icon: const Icon(Icons.map),
                    tooltip: S.of(context).switchToMapView,
                    onPressed: locationServiceAvailable == false
                        ? null
                        : () {
                            setState(() {
                              viewMode = ViewMode.map;
                            });
                            widget.canVibrate.then((value) {
                              Vibrate.feedback(FeedbackType.selection);
                            });
                          },
                  )
                : IconButton(
                    icon: const Icon(Icons.list),
                    tooltip: S.of(context).switchToListView,
                    onPressed: () {
                      setState(() {
                        viewMode = ViewMode.list;
                      });
                      widget.canVibrate.then((value) {
                        Vibrate.feedback(FeedbackType.selection);
                      });
                    },
                  ),
            // REFRESH LIST
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: S.of(context).refresh,
              onPressed: () {
                _refreshIndicatorKey.currentState?.show();
              },
            ),
          ]),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          displacement: 60.0,
          onRefresh: () {
            return refreshGyms(context);
          },
          child: widgetToShow),
      drawer: DrawerMenu(
          widget.user,
          widget.signOut,
          widget.signedIn,
          widget.register,
          widget.openSettings,
          widget.isAppleSignInAvailable,
          widget.isGoogleSignInAvailable,
          widget.api,
          widget.canVibrate),
    );
  }
}
