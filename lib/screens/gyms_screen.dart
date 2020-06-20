import 'package:climbing/api/api.dart' as api;
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/models/app_state.dart';
import 'package:climbing/models/gym.dart';
import 'package:climbing/ui/widgets/gyms/location_service_unavailable.dart';
import 'package:flutter/material.dart';

import '../keys.dart' as keys;
import '../typedefs.dart';
import '../ui/widgets/drawer_menu_widget.dart';
import '../ui/widgets/gyms/gyms_list.dart';
import '../ui/widgets/gyms/gyms_map.dart';

enum ScreenTabs { list, map }

class GymsScreen extends StatefulWidget {
  const GymsScreen(
      {@required this.appState,
      @required this.signOut,
      @required this.signIn,
      @required this.updateUser,
      @required this.feedback,
      @required this.updateCoordinates,
      @required this.fetchGyms})
      : super(key: keys.gymsListScreen);

  static const String routeName = '/gyms';
  final AppState appState;
  final SignInCallback signIn;
  final SignOutCallback signOut;
  final UpdateUserCallback updateUser;
  final FeedbackCallback feedback;
  final UpdateCoordinatesCallback updateCoordinates;
  final FetchGymsCallback fetchGyms;

  @override
  _GymsScreenState createState() => _GymsScreenState();
}

enum GymListPopupMenuItems { purgeCurrentCoordinatesCache, purgeAllCache }
enum GymsFilter { showAllGyms, showHiddenGyms, showVisibleGyms }

class _GymsScreenState extends State<GymsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScreenTabs activeTab = ScreenTabs.list;
  GymsFilter activeFilter = GymsFilter.showAllGyms;
  int _allGymsCount;
  int _hiddenGymsCount;
  int _visibleGymsCount;

  void _updateFilter(GymsFilter filter) {
    setState(() {
      activeFilter = filter;
    });
  }

  void _updateTab(ScreenTabs tab) {
    setState(() {
      activeTab = tab;
    });
  }

  void _calculateStatistics(List<Gym> gyms) {
    _allGymsCount = gyms.length;
    _visibleGymsCount = 0;
    for (final Gym gym in gyms) {
      if (gym.visible) {
        _visibleGymsCount++;
      }
    }
    _hiddenGymsCount = _allGymsCount - _visibleGymsCount;
  }

  String getTitle(GymsFilter activeFilter){
    String title;
    switch (activeFilter){
      case GymsFilter.showAllGyms:
        title = S.of(context).showAllGyms(_allGymsCount);
        break;
      case GymsFilter.showHiddenGyms:
        title =  S.of(context).hiddenWithCount(_hiddenGymsCount);
        break;
      case GymsFilter.showVisibleGyms:
        title =  S.of(context).visibleWithCount(_visibleGymsCount);
    }
    return title;
  }

  void _popupMenuSelect(GymListPopupMenuItems choice) {
    switch (choice) {
      case GymListPopupMenuItems.purgeCurrentCoordinatesCache:
        api.purgeYelpCacheForCoordinates(widget.appState.coordinates);
        break;
      case GymListPopupMenuItems.purgeAllCache:
        api.purgeYelpCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    _calculateStatistics(widget.appState.gyms);
    final List<Widget> actions = <Widget>[];
    final AppState appState = widget.appState;
    // ADMIN USER CONTEXT MENUS
    if (appState.user != null && appState.user.isAdmin()) {
      // FILTER MENU
      actions.add(PopupMenuButton<GymsFilter>(
        enabled: appState.locationServiceEnabled &&
            appState.locationServicePermitted,
        icon: const Icon(Icons.filter_list),
        initialValue: activeFilter,
        onSelected: _updateFilter,
        itemBuilder: (BuildContext context) => <PopupMenuItem<GymsFilter>>[
          PopupMenuItem<GymsFilter>(
            value: GymsFilter.showVisibleGyms,
            child: Text(
                S.of(context).showVisibleGyms(_visibleGymsCount.toString())),
          ),
          PopupMenuItem<GymsFilter>(
            value: GymsFilter.showHiddenGyms,
            child:
                Text(S.of(context).showHiddenGyms(_hiddenGymsCount.toString())),
          ),
          PopupMenuItem<GymsFilter>(
            value: GymsFilter.showAllGyms,
            child: Text(S.of(context).showAllGyms(_allGymsCount.toString())),
          ),
        ],
      ));
      // POPUP MENU
      actions.add(PopupMenuButton<GymListPopupMenuItems>(
        enabled: appState.locationServiceEnabled &&
            appState.locationServicePermitted,
        onSelected: _popupMenuSelect,
        itemBuilder: (BuildContext context) =>
            <PopupMenuItem<GymListPopupMenuItems>>[
          PopupMenuItem<GymListPopupMenuItems>(
            value: GymListPopupMenuItems.purgeCurrentCoordinatesCache,
            child: Text(S.of(context).purgeCurrentCoordinatesCache),
          ),
          PopupMenuItem<GymListPopupMenuItems>(
            value: GymListPopupMenuItems.purgeAllCache,
            child: Text(S.of(context).purgeAllCache),
          )
        ],
      ));
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            centerTitle: true,
            title: Text(getTitle(activeFilter)),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              tooltip: S.of(context).menu,
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            actions: actions),
        body: !appState.locationServiceEnabled ||
                !appState.locationServicePermitted
            ? LocationServiceUnavailable(appState: appState)
            : activeTab == ScreenTabs.list
                ? GymsList(
                    gyms: appState.filteredGyms(activeFilter),
                    user: appState.user,
                    fetchGyms: widget.fetchGyms,
                  )
                : GymsMap(
                    gyms: appState.filteredGyms(activeFilter),
                    updateCoordinates: widget.updateCoordinates,
                    updateUser: widget.updateUser,
                    signIn: widget.signIn,
                    coordinates: appState.coordinates,
                  ),
        drawer: DrawerMenu(
            appState: appState,
            signOut: widget.signOut,
            signIn: widget.signIn,
            feedback: widget.feedback,
            updateUser: widget.updateUser),
        bottomNavigationBar: appState.locationServiceEnabled ||
                appState.locationServicePermitted
            ? BottomNavigationBar(
                currentIndex: ScreenTabs.values.indexOf(activeTab),
                onTap: (int index) {
                  _updateTab(ScreenTabs.values[index]);
                },
                items: ScreenTabs.values.map((ScreenTabs tab) {
                  return BottomNavigationBarItem(
                    icon: Icon(tab == ScreenTabs.list ? Icons.list : Icons.map,
                        key: tab == ScreenTabs.list
                            ? keys.listTab
                            : keys.mapsTab),
                    title: Text(
                      tab == ScreenTabs.list
                          ? S.of(context).list
                          : S.of(context).map,
                    ),
                  );
                }).toList(),
              )
            : null);
  }
}
