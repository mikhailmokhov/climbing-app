import 'dart:async';

import 'package:climbing/classes/gyms_response.dart';

import 'package:climbing/classes/user.dart';
import 'package:climbing/services/api_service.dart';
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
  final ApiService api;
  final Future<bool> canVibrate;
  final Future<dynamic> Function(User) updateUser;

  GymsView({
    @required this.user,
    @required this.signOut,
    @required this.signedIn,
    @required this.register,
    @required this.openSettings,
    @required this.editAccount,
    @required this.api,
    @required this.canVibrate,
    @required this.updateUser,
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
  StreamSubscription connectivitySubscription;
  ConnectivityResult connectivityStatus;

  List<Gym> gyms = [];
  Coordinates coordinates;
  GymsProvider provider;
  Widget widgetToShow;
  Flushbar flushbar;
  bool pendingRequest = false;

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
    flushbar?.dismiss();
    flushbar = Flushbar(
      message: error,
      backgroundColor: Colors.deepOrange,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    )
      ..show(context);
  }

  openLocationSettings() async {
    bool result = await OpenLocationSettingsDialog.show(
        context, geolocationStatus, serviceStatus);
    if (result) {
      Future.delayed(const Duration(milliseconds: 200), () {
        // delay to wait for the dialog to close
        OpenLocationSettingsDialog.openSettings(
            geolocationStatus, serviceStatus);
      });
    } else {
      setState(() {});
    }
  }

  refresh() {
    //show refresh indicator which should trigger onRefresh event
    _refreshIndicatorKey.currentState?.show();
  }

  triggerConnectivityError() {
    if (connectivityStatus == ConnectivityResult.none) {
      showError(S
          .of(this.context)
          .noInternetConnection);
    } else {
      flushbar?.dismiss();
    }
  }

  setConnectivityStatus() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    connectivityStatus = result;
    triggerConnectivityError();
  }

  connectivityOnChange(ConnectivityResult result) {
    connectivityStatus = result;
    triggerConnectivityError();
    if (pendingRequest) refresh();
  }

  setLocationPermissions() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
    serviceStatus = await LocationPermissions().checkServiceStatus();
    switch (geolocationStatus) {
      case GeolocationStatus.unknown:
        locationServiceAvailable = true;
        break;
      case GeolocationStatus.granted:
        locationServiceAvailable = true;
        break;
      case GeolocationStatus.denied:
      default:
        locationServiceAvailable = false;
        openLocationSettings();
    }
  }

  setLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest)
        .then((Position position) {
      coordinates = Coordinates(position.latitude, position.longitude);
    }).catchError((error) {
      locationServiceAvailable = false;
    });
  }

  onRefresh(BuildContext context) async {
    await setConnectivityStatus();
    if (connectivityStatus == ConnectivityResult.none) {
      pendingRequest = true;
      return;
    }
    if (coordinates == null) {
      await setLocationPermissions();
      if (locationServiceAvailable == false) return;
      await setLocation();
      if (coordinates == null) return;
    }
    try {
      GymsResponse gymsResponse = await ApiService.gyms(coordinates);
      setState(() {
        provider = gymsResponse.provider;
        gyms = gymsResponse.gyms;
        pendingRequest = false;
      });
    } catch (error) {
      showError(error.toString());
    }
    return;
  }

  @override
  initState() {
    super.initState();
    // subscribe to network connection change
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(connectivityOnChange);
    WidgetsBinding.instance
      ..addPostFrameCallback((_) {
        refresh();
      })
      ..addObserver(this); // didChangeAppLifecycleState
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (locationServiceAvailable == false && state == AppLifecycleState.resumed)
      refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (locationServiceAvailable == false) {
      widgetToShow = LocationDisabled(geolocationStatus, serviceStatus);
    } else if (viewMode == ViewMode.list) {
      if (gyms?.length == 0 && provider != null) {
        widgetToShow = EmptyResponse();
      } else {
        widgetToShow = GymsList(onRefresh, gymOnTap, _refreshIndicatorKey, gyms,
            coordinates, provider);
      }
    } else {
      widgetToShow =
          GymsMap(coordinates, gyms, setCoordinates, _refreshIndicatorKey);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(S
              .of(context)
              .gymsList_title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: S
                .of(context)
                .menu,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            viewMode == ViewMode.list
                ? IconButton(
              icon: const Icon(Icons.map),
              tooltip: S
                  .of(context)
                  .switchToMapView,
              onPressed: locationServiceAvailable == false ||
                  connectivityStatus == ConnectivityResult.none
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
              tooltip: S
                  .of(context)
                  .switchToListView,
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
              tooltip: S
                  .of(context)
                  .refresh,
              onPressed: () {
                refresh();
              },
            ),
          ]),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          displacement: 60.0,
          onRefresh: () {
            return onRefresh(context);
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
          widget.canVibrate,
          updateUser: this.widget.updateUser),
    );
  }
}
