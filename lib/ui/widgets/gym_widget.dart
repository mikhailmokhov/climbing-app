import 'dart:async';

import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/models/gyms_response.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/services/api_service.dart';
import 'package:climbing/ui/buttons/bookmark_button.dart';
import 'package:climbing/models/climbing_route.dart';
import 'package:climbing/models/gym.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/utils/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibrate/vibrate.dart';
import 'gym_title_yelp.dart';
import 'my_flexible_space_bar.dart';

class GymWidget extends StatefulWidget {
  static const String routeName = '/gym';
  final Gym gym;
  final User user;
  final Set<SignInProvider> signInProviderSet;
  final void Function() updateUserCallback;
  final Future<bool> Function(SignInProvider) signIn;

  const GymWidget(
      this.gym, this.user, this.updateUserCallback, this.signIn, this.signInProviderSet,
      {Key key})
      : super(key: key);

  @override
  _GymWidgetState createState() => _GymWidgetState();
}

enum GymPopupMenuItems { hideBusiness, unhideBusiness }

class _GymWidgetState extends State<GymWidget> {
  final double _appBarHeight = 256.0;
  List<ClimbingRoute> routes = [];
  Flushbar _flushbar;
  BuildContext _buildContext;
  bool _savingBookmarkInProgress = false;
  bool _removingBookmarkInProgress = false;
  bool _saveBookmarkAfterSignIn = false;
  Timer _timer;
  bool _canVibrate = false;

  _launchURL(String url) async {
    //TODO add code for handling launching Yelp app
    //yelp4:///search?terms=Coffee
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void handleError(dynamic e) {
    Utils.showError(_flushbar, e, _buildContext);
  }

  void _triggerBookmark(bool selected) {
    if (_timer != null) _timer.cancel();
    _timer = Timer(Duration(milliseconds: 500), () {
      if (selected && !widget.user.homeGymIds.contains(widget.gym.id)) {
        _saveBookmark();
      } else if (!selected && widget.user.homeGymIds.contains(widget.gym.id)) {
        _removeBookmark();
      }
    });
  }

  void _saveBookmark() async {
    assert(widget.user != null);
    String gymId;
    try {
      _savingBookmarkInProgress = true;
      if (widget.gym.id != null && widget.gym.id.isNotEmpty) {
        gymId = await ApiService.saveBookmark(
            GymsProvider.INTERNAL, this.widget.gym.id);
      } else if (widget.gym.yelpId != null && widget.gym.yelpId.isNotEmpty) {
        gymId = await ApiService.saveBookmark(
            GymsProvider.YELP, this.widget.gym.yelpId);
      } else if (widget.gym.googleId != null && widget.gym.googleId.isEmpty) {
        gymId = await ApiService.saveBookmark(
            GymsProvider.GOOGLE, this.widget.gym.googleId);
      } else {
        throw Exception("Gym does not have any ids");
      }
      _savingBookmarkInProgress = false;
      if (gymId == null || gymId.isEmpty) throw Exception("Gym id is invalid");
      if (!_timer.isActive &&
          !_savingBookmarkInProgress &&
          !_removingBookmarkInProgress) {
        setState(() {
          widget.gym.id = gymId;
          if (!widget.user.homeGymIds.contains(gymId))
            widget.user.homeGymIds.add(gymId);
        });
      }
      widget.updateUserCallback();
    } catch (e) {
      _savingBookmarkInProgress = false;
      handleError(e);
    }
  }

  void _removeBookmark() async {
    assert(widget.user != null);
    try {
      _removingBookmarkInProgress = true;
      await ApiService.removeHomeGym(widget.gym.id);
      _removingBookmarkInProgress = false;
      if (!_timer.isActive &&
          !_savingBookmarkInProgress &&
          !_removingBookmarkInProgress) {
        setState(() {
          widget.user.homeGymIds.remove(widget.gym.id);
        });
      }
      widget.updateUserCallback();
    } catch (e) {
      _removingBookmarkInProgress = false;
      handleError(e);
    }
  }

  @override
  initState() {
    super.initState();
    Vibrate.canVibrate.then((value) => _canVibrate = value);
    if(_saveBookmarkAfterSignIn) {
      _saveBookmarkAfterSignIn = false;
      _saveBookmark();
    }
//    RoutesProvider.getRoutes(this.widget.gym.googleId).then((result) {
//      setState(() {
//        routes = result;
//      });
//    });
  }

  // CONTEXT MENU HANDLER
  void _select(GymPopupMenuItems choice) {
    switch (choice) {
      case GymPopupMenuItems.hideBusiness:
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).hideBusinessQuestion),
              actions: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  child: Text(S.of(context).YES),
                  onPressed: () {
                    ApiService.setVisibility(this.widget.gym, false)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                ),
                FlatButton(
                  child: Text(S.of(context).NO),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        break;
      case GymPopupMenuItems.unhideBusiness:
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).unhideBusinessQuestion),
              actions: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  child: Text(S.of(context).YES),
                  onPressed: () {
                    ApiService.setVisibility(this.widget.gym, true)
                        .then((value) {
                      Navigator.pop(context);
                    });
                  },
                ),
                FlatButton(
                  child: Text(S.of(context).NO),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    _buildContext = context;
//    // ROUTES
//    List<GridTile> gridTiles = routes.map((route) {
//      return GridTile(
//        footer: GestureDetector(
//          onTap: () {},
//          child: GridTileBar(
//            backgroundColor: Colors.black45,
//            title: Text(
//              route.grade == null ? "" : route.grade.getScaled(GradeScales.YSD),
//              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//            ),
//            subtitle: Text('subtitle'),
//            trailing: RatingBarIndicator(
//              rating: route.rating,
//              unratedColor: Colors.black,
//              itemBuilder: (context, index) => Icon(
//                Icons.star,
//                color: Colors.white,
//              ),
//              itemCount: 4,
//              itemSize: 20,
//              itemPadding: EdgeInsets.symmetric(horizontal: 1.5),
//            ),
//          ),
//        ),
//        child: GestureDetector(
//          onTap: () {},
//          child: Hero(
//            tag: route.id,
//            child: Image.asset(
//              'images/IMG_6339.jpeg',
//              fit: BoxFit.cover,
//            ),
//          ),
//        ),
//      );
//    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: this.widget.user != null && this.widget.user.isAdmin()
                ? <Widget>[
                    PopupMenuButton<GymPopupMenuItems>(
                      onSelected: _select,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<GymPopupMenuItems>>[
                        PopupMenuItem(
                          value: this.widget.gym.hidden
                              ? GymPopupMenuItems.unhideBusiness
                              : GymPopupMenuItems.hideBusiness,
                          child: Text(this.widget.gym.hidden
                              ? S.of(context).unhideBusiness
                              : S.of(context).hideBusiness),
                        ),
                      ],
                    ),
                  ]
                : null,
            expandedHeight: _appBarHeight,
            pinned: true,
            floating: true,
            snap: true,
            flexibleSpace: MyFlexibleSpaceBar(
              centerTitle: true,
              title: SizedBox(
                  width: 250.0,
                  child: AutoSizeText(widget.gym.name,
                      textAlign: TextAlign.center,
                      style: new TextStyle(shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black,
                          offset: Offset(0.0, 0.0),
                        ),
                      ]),
                      overflow: TextOverflow.fade,
                      maxLines: 1)),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(
                    this.widget.gym.getImageUrl(width: 1125),
                    fit: BoxFit.cover,
                    height: _appBarHeight,
                  ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
              collapseMode: CollapseMode.parallax,
              onYelpLogoTap: (){
                if (_canVibrate)
                  Vibrate.feedback(FeedbackType.selection);
                _launchURL(widget.gym.yelpUrl);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.only(top: 10, left: 17, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GymTitleYelp(widget.gym.name, widget.gym.yelpRating,
                        widget.gym.yelpReviewCount),
                    widget.user == null
                        ? BookmarkButton(
                            tooltip: S.of(context).saveToBookmarks,
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text(
                                        "You need to be signed to manage bookmarks"),
                                    actions: <Widget>[
                                      RaisedButton(
                                        child: Text("Sign in / Sign up"),
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          Utils.showSignInDialog(context, widget.signInProviderSet, (SignInProvider signInProvider){
                                            widget.signIn(signInProvider).then((bool signedIn){
                                              _saveBookmarkAfterSignIn = true;
                                            });
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            size: 35,
                            feedbackVibration: true,
                            icon: Icons.bookmark_border,
                          )
                        : BookmarkButton.toggleable(
                            tooltip: S.of(context).saveToBookmarks,
                            selected: widget.user != null &&
                                widget.user.homeGymIds != null &&
                                widget.gym.id != null &&
                                widget.user.homeGymIds.contains(widget.gym.id),
                            onChange: _triggerBookmark,
                            size: 35,
                            iconSelected: Icons.bookmark,
                            iconUnselected: Icons.bookmark_border,
                            feedbackVibration: true,
                          )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
              )
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 2.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 0.666,
              children: [],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("ROUTE"),
        icon: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          //ImagePicker.pickImage(source: ImageSource.gallery).then((image){

          //});
        },
      ),
    );
  }
}
