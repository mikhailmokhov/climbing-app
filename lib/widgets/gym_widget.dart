import 'package:climbing/classes/grade_scale_class.dart';
import 'package:climbing/classes/routes_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:climbing/classes/climbing_route_class.dart';
import 'package:climbing/classes/gym_class.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';

import 'my_flexible_space_bar.dart';

class GymWidget extends StatefulWidget {
  static const String routeName = '/gym';
  final Gym gym;

  const GymWidget(this.gym, {Key key}) : super(key: key);

  @override
  _GymWidgetState createState() => _GymWidgetState();
}

class _GymWidgetState extends State<GymWidget> {
  final double _appBarHeight = 256.0;
  List<ClimbingRoute> routes =[];

  @override
  initState() {
    super.initState();
    RoutesProvider.getRoutes(this.widget.gym.googlePlaceId).then((result) {
      setState(() {
        routes = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              alpha: 100,
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
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_horiz),
                tooltip: S.of(context).switchToMapView,
                onPressed: () {
                  //TODO: add code for switching to info view
                },
              )
            ],
            expandedHeight: _appBarHeight,
            pinned: true,
            floating: true,
            snap: true,
            flexibleSpace: MyFlexibleSpaceBar(
              centerTitle: true,
              title: SizedBox(
                width: 220.0,
                child: Text(
                  this.widget.gym.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(
                    this.widget.gym.getGooglePhotoUrl(width: 1125),
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
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 2.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 0.666,
              children: gridTiles,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
            //ImagePicker.pickImage(source: ImageSource.gallery).then((image){

            //});
        },
      ),
    );
  }
}
