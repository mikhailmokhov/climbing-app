import 'package:climbing/classes/gym_class.dart';
import 'package:climbing/classes/climbing_route_class.dart';
import 'package:flutter/material.dart';

class RoutesGrid extends StatefulWidget {
  const RoutesGrid({Key key}) : super(key: key);

  @override
  _RoutesGridState createState() => _RoutesGridState();
}

class _RoutesGridState extends State<RoutesGrid> {

  Gym gym = new Gym.fromYelpMap(new Map());

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.count(
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            padding: const EdgeInsets.all(4.0),
            childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
            children: gym.routes.map<Widget>((ClimbingRoute route) {
              return RouteGridItem(
                photo: route,
                onBannerTap: (ClimbingRoute photo) {
                  setState(() {});
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

typedef BannerTapCallback = void Function(ClimbingRoute photo);

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(text),
    );
  }
}

class RouteGridItem extends StatelessWidget {
  RouteGridItem({
    Key key,
    @required this.photo,
    @required this.onBannerTap,
  })  : assert(photo != null),
        assert(onBannerTap != null),
        super(key: key);

  final ClimbingRoute photo;
  final BannerTapCallback
      onBannerTap; // User taps on the photo's header or footer.

  void showPhoto(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Some text'),
        ),
        body: SizedBox.expand(
          child: Hero(
            tag: 'Some tag',
            child: GridPhotoViewer(),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = GestureDetector(
      onTap: () {
        showPhoto(context);
      },
      child: Hero(
        key: Key('images/powered_by_google_on_white2x.png'),
        tag: 'Some tag',
        child: Image.asset(
          'images/powered_by_google_on_white2x.png',
          fit: BoxFit.cover,
        ),
      ),
    );

    return GridTile(
      footer: GestureDetector(
        onTap: () {
          onBannerTap(photo);
        },
        child: GridTileBar(
          backgroundColor: Colors.black45,
          title: _GridTitleText('Some title'),
          subtitle: _GridTitleText('Some caption'),
          trailing: Icon(
            Icons.description,
            color: Colors.white,
          ),
        ),
      ),
      child: image,
    );
  }
}

class GridPhotoViewer extends StatelessWidget {
  const GridPhotoViewer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('SOm text');
  }
}
