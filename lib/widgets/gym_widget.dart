import 'package:climbing/models/grade_scale_class.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/services/api_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:climbing/models/climbing_route_class.dart';
import 'package:climbing/models/gym_class.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'gyms/open_yelp.dart';
import 'my_flexible_space_bar.dart';

class GymWidget extends StatefulWidget {
  static const String routeName = '/gym';
  final Gym gym;
  final User user;

  const GymWidget(this.gym, this.user, {Key key}) : super(key: key);

  @override
  _GymWidgetState createState() => _GymWidgetState();
}

enum GymPopupMenuItems { hideBusiness, unHideBusiness, addToHomeGyms }

class _GymWidgetState extends State<GymWidget> {
  final double _appBarHeight = 256.0;
  List<ClimbingRoute> routes = [];

  @override
  initState() {
    super.initState();
//    RoutesProvider.getRoutes(this.widget.gym.googleId).then((result) {
//      setState(() {
//        routes = result;
//      });
//    });
  }

  // CONTEXT MENU HANDLER
  void _select(GymPopupMenuItems choice) {
    switch (choice) {
      case GymPopupMenuItems.addToHomeGyms:
        ApiService.addHomeGym(this.widget.gym);
        return;
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
      case GymPopupMenuItems.unHideBusiness:
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

    // ROUTES
    List<GridTile> gridTiles = routes.map((route) {
      return GridTile(
        footer: GestureDetector(
          onTap: () {},
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
              route.grade == null ? "" : route.grade.getScaled(GradeScales.YSD),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('subtitle'),
            trailing: RatingBarIndicator(
              rating: route.rating,
              unratedColor: Colors.black,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.white,
              ),
              itemCount: 4,
              itemSize: 20,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.5),
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Hero(
            tag: route.id,
            child: Image.asset(
              'images/IMG_6339.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList();

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
                              ? GymPopupMenuItems.unHideBusiness
                              : GymPopupMenuItems.hideBusiness,
                          child: Text(this.widget.gym.hidden
                              ? S.of(context).unhideBusiness
                              : S.of(context).hideBusiness),
                        ),
                        this.widget.gym.hidden
                            ? null
                            : PopupMenuItem(
                                value: GymPopupMenuItems.addToHomeGyms,
                                child: Text(S.of(context).addToHomeGyms),
                              )
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
                  child: AutoSizeText(this.widget.gym.name,
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
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  Text("Test1"),
                  Text("Test2"),
                  OpenYelp(
                    url: this.widget.gym.yelpUrl,
                    opacity: 1, width: 70,
                  )
                ],
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //ImagePicker.pickImage(source: ImageSource.gallery).then((image){

          //});
        },
      ),
    );
  }
}
