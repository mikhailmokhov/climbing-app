import 'dart:async';

import 'package:climbing/models/gyms_response.dart';

import 'package:climbing/models/user.dart';
import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/services/api_service.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:climbing/models/gym.dart';
import 'package:climbing/models/my_location.dart';
import 'package:climbing/generated/l10n.dart';

import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:vibrate/vibrate.dart';
import 'package:flushbar/flushbar.dart';
import '../drawer_menu_widget.dart';
import '../gym_widget.dart';

import 'gyms_list.dart';
import 'disabled_location_utils.dart';
import 'gyms_list_empty_response.dart';
import 'gyms_map.dart';

enum ViewMode { list, map }

class GymsView extends StatefulWidget {
  static const String routeName = '/gymslist';
  final User user;
  final Function(SignInProvider) signIn;
  final Function signOut, editAccount;
  final Set<SignInProvider> signInProviderSet;
  final void Function() updateUserCallback;

  GymsView({
    @required this.user,
    @required this.signOut,
    @required this.signIn,
    @required this.editAccount,
    @required this.updateUserCallback,
    @required this.signInProviderSet,
    Key key
  }) : super(key: key);

  @override
  _GymsViewState createState() => _GymsViewState();
}

enum GymListPopupMenuItems { purgeCurrentCoordinatesCache, purgeAllCache }
enum GymListViewMode { allGyms, hiddenGyms }

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
  GymListViewMode gymListViewMode = GymListViewMode.allGyms;
  bool _canVibrate = false;

  List<Gym> gyms = [];
  Coordinates coordinates;
  GymsProvider provider;
  Widget mainViewWidget;
  Flushbar flushbar;
  bool pendingRequest = false;

  void _updateUsersHomeGymsCallback(){
    setState(() { });
  }

  gymOnTap(Gym gym, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GymWidget(gym, this.widget.user, _updateUsersHomeGymsCallback)),
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
    )..show(context);
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
      showError(S.of(this.context).noInternetConnection);
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
      GymsResponse gymsResponse = await ApiService.getGyms(coordinates);
      setState(() {
        provider = gymsResponse.provider;
        gyms = gymsResponse.businesses;
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
    Vibrate.canVibrate.then((value) => _canVibrate = value);
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

  void _popupMenuSelect(GymListPopupMenuItems choice) {
    switch (choice) {
      case GymListPopupMenuItems.purgeCurrentCoordinatesCache:
        ApiService.purgeYelpCacheForCoordinates(
            coordinates.latitude, coordinates.longitude);
        return;
      case GymListPopupMenuItems.purgeAllCache:
        ApiService.purgeYelpCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (locationServiceAvailable == false) {
      mainViewWidget = LocationDisabled(geolocationStatus, serviceStatus);
    } else if (viewMode == ViewMode.list) {
      if (gyms?.length == 0 && provider != null) {
        mainViewWidget = EmptyResponse();
      } else {
        mainViewWidget = GymsList(onRefresh, gymOnTap, _refreshIndicatorKey, gyms,
            coordinates, provider, gymListViewMode, widget.user);
      }
    } else {
      mainViewWidget = GymsMap(coordinates, gyms, setCoordinates,
          _refreshIndicatorKey, this.widget.user, this.widget.updateUserCallback);
    }

    List<Widget> actions = <Widget>[
      // REFRESH LIST
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: S.of(context).refresh,
        onPressed: () {
          refresh();
        },
      ),
      // VIEW MODE
      viewMode == ViewMode.list
          ? IconButton(
              icon: const Icon(Icons.map),
              tooltip: S.of(context).mapView,
              onPressed: locationServiceAvailable == false ||
                      connectivityStatus == ConnectivityResult.none
                  ? null
                  : () {
                      setState(() {
                        viewMode = ViewMode.map;
                      });
                      if(_canVibrate) Vibrate.feedback(FeedbackType.selection);
                    },
            )
          : IconButton(
              icon: const Icon(Icons.list),
              tooltip: S.of(context).listView,
              onPressed: () {
                setState(() {
                  viewMode = ViewMode.list;
                });
                if(_canVibrate) Vibrate.feedback(FeedbackType.selection);
              },
            )
    ];

    Widget titleWidget;
    if (this.widget.user != null && this.widget.user.isAdmin()) {
      // MORE ACTIONS POPUP MENU
      actions.add(
          PopupMenuButton<GymListPopupMenuItems>(
        onSelected: _popupMenuSelect,
        itemBuilder: (BuildContext context) =>
            <PopupMenuItem<GymListPopupMenuItems>>[
          PopupMenuItem(
            value: GymListPopupMenuItems.purgeCurrentCoordinatesCache,
            child: Text(S.of(context).purgeCurrentCoordinatesCache),
          ),
          PopupMenuItem(
            value: GymListPopupMenuItems.purgeAllCache,
            child: Text(S.of(context).purgeAllCache),
          )
        ],
      ));

      titleWidget = InkWell(
          onTap: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // ALL GYMS
                        RadioListTile<GymListViewMode>(
                          onChanged: (GymListViewMode value) {
                            setState(() {
                              gymListViewMode = value;
                              Navigator.pop(context);
                            });
                          },
                          value: GymListViewMode.allGyms,
                          groupValue: gymListViewMode,
                          title: new Text(S.of(context).allGyms),
                        ),
                        // HIDDEN GYMS
                        RadioListTile<GymListViewMode>(
                          onChanged: (GymListViewMode value) {
                            setState(() {
                              gymListViewMode = value;
                              Navigator.pop(context);
                            });
                          },
                          value: GymListViewMode.hiddenGyms,
                          groupValue: gymListViewMode,
                          title: new Text(S.of(context).hiddenGyms),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.keyboard_arrow_down),
              gymListViewMode == GymListViewMode.allGyms
                  ? Text(S.of(context).gymsListTitle)
                  : Text(S.of(context).hiddenGyms)
            ],
          ));
    } else {
      titleWidget = Text(S.of(context).gymsListTitle);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: titleWidget,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: S.of(context).menu,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: actions),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          displacement: 60.0,
          onRefresh: () {
            return onRefresh(context);
          },
          child: mainViewWidget),
      drawer: DrawerMenu(
          user: widget.user,
          signOut: widget.signOut,
          signIn: widget.signIn,
          signInProviderSet: widget.signInProviderSet,
          updateUserCallback: this.widget.updateUserCallback),
    );
  }
}
