import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/api/api.dart' as api;
import 'package:climbing/models/app_state.dart';
import 'package:climbing/models/climbing_route.dart';
import 'package:climbing/models/gym.dart';
import 'package:climbing/ui/buttons/bookmark_button.dart';
import 'package:climbing/ui/widgets/take_picture_widget.dart';
import 'package:climbing/utils/utils.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibrate/vibrate.dart';

import '../typedefs.dart';
import '../ui/widgets/gym_title_yelp.dart';
import '../ui/widgets/my_flexible_space_bar.dart';

class GymScreenArguments {
  GymScreenArguments(this.gym);

  final Gym gym;
}

class GymScreen extends StatefulWidget {
  const GymScreen(
      {@required this.appState,
      @required this.updateUser,
      @required this.updateGym,
      @required this.signIn,
      @required this.feedback,
      Key key})
      : super(key: key);

  static const String routeName = '/gym';

  final AppState appState;
  final UpdateUserCallback updateUser;
  final UpdateGymCallback updateGym;
  final SignInCallback signIn;
  final FeedbackCallback feedback;

  @override
  _GymScreenState createState() => _GymScreenState();
}

enum GymPopupMenuItems { hideBusiness, unhideBusiness }

class _GymScreenState extends State<GymScreen> {
  final double _appBarHeight = 256.0;
  List<ClimbingRoute> routes = <ClimbingRoute>[];
  Flushbar<void> _flushbar;
  BuildContext _buildContext;
  Timer _timer;
  bool _bookmarked;
  CameraDescription _firstCamera;
  Gym gym;

  Future<void> _launchURL(String url) async {
    // TODO(Mikhail): add code for handling launching Yelp app
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

  void _triggerBookmarkTimer(bool selected) {
    _bookmarked = selected;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500),
        selected ? _saveBookmark : _removeBookmark);
  }

  Future<void> _saveBookmark() async {
    assert(widget.appState.user != null);
    try {
      final String gymId = await api.addGymToBookmarks(gym.getFirstGymId());
      final Set<String> bookmarks = widget.appState.user.bookmarks;
      bookmarks.add(gymId);
      widget.updateUser(bookmarks: bookmarks);
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> _removeBookmark() async {
    assert(widget.appState.user != null);
    try {
      await api.removeGymFromBookmarks(gym.id);
      final Set<String> bookmarks = widget.appState.user.bookmarks;
      bookmarks.remove(gym.id);
      widget.updateUser(bookmarks: bookmarks);
    } catch (e) {
      handleError(e);
    }
  }

  @override
  void initState() {
    super.initState();

    // CAMERA: Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    availableCameras().then((List<CameraDescription> cameras) {
      if (cameras.isNotEmpty) {
        _firstCamera = cameras.first;
      }
    });
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
                    api.setGymVisibility(gym.getFirstGymId(), false).then((_) {
                      Navigator.pop(context);
                      widget.updateGym(
                        gym, visible: false
                      );
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
                    api.setGymVisibility(gym.getFirstGymId(), true).then((_) {
                      Navigator.pop(context);
                      widget.updateGym(gym, visible: true);
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

    final GymScreenArguments args =
        ModalRoute.of(context).settings.arguments as GymScreenArguments;
    gym = args.gym;

    _bookmarked = widget.appState.user != null &&
        widget.appState.user.bookmarks != null &&
        gym.id != null &&
        widget.appState.user.bookmarks.contains(gym.id);
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
            actions:
                widget.appState.user != null && widget.appState.user.isAdmin()
                    ? <Widget>[
                        PopupMenuButton<GymPopupMenuItems>(
                          onSelected: _select,
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<GymPopupMenuItems>>[
                            PopupMenuItem<GymPopupMenuItems>(
                              value: gym.visible
                                  ? GymPopupMenuItems.hideBusiness
                                  : GymPopupMenuItems.unhideBusiness,
                              child: Text(gym.visible
                                  ? S.of(context).hideBusiness
                                  : S.of(context).unhideBusiness),
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
                  child: AutoSizeText(gym.getName(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(shadows: <Shadow>[
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
                    gym.getImageUrl(),
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
              onYelpLogoTap: () {
                widget.feedback(FeedbackType.selection);
                _launchURL(gym.yelpUrl);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10, left: 17, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GymTitleYelp(
                        gym.getName(), gym.yelpRating, gym.yelpReviewCount),
                    if (widget.appState.user == null)
                      BookmarkButton(
                        tooltip: S.of(context).saveToBookmarks,
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text(S.of(context).youNeedToBeSignedIn),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text(S.of(context).signInSignUp),
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      Utils.showSignInDialog(context,
                                          widget.appState.signInProviderSet,
                                          (SignInProvider signInProvider) {
                                        widget
                                            .signIn(signInProvider)
                                            .then((bool signedIn) {
                                          setState(() {
                                            _triggerBookmarkTimer(true);
                                          });
                                        });
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(S.of(context).cancel),
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
                    else
                      BookmarkButton.toggleable(
                        tooltip: S.of(context).saveToBookmarks,
                        selected: _bookmarked,
                        onChange: _triggerBookmarkTimer,
                        size: 35,
                        iconSelected: Icons.bookmark,
                        iconUnselected: Icons.bookmark_border,
                        feedbackVibration: true,
                      )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[],
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
              children: const <Widget>[],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.photo_camera,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return TakePictureScreen(
                  camera: _firstCamera,
                );
              },
              fullscreenDialog: true));

//          ImagePicker.pickImage(source: ImageSource.camera).then((image){
//
//          });
        },
      ),
    );
  }
}
