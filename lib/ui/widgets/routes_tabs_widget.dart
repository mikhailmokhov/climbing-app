import 'dart:io';

import 'package:climbing/models/gym.dart';
import 'package:flutter/material.dart';
import 'package:climbing/models/climbing_route.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';

enum Sorting { difficulty, newestFirst }

class RoutesTabs extends StatefulWidget {
  static const String routeName = '/routeslist';
  final Gym gym;

  const RoutesTabs(this.gym, {Key key}) : super(key: key);

  @override
  _RoutesTabsState createState() => _RoutesTabsState();
}

class _RoutesTabsState extends State<RoutesTabs>
    with SingleTickerProviderStateMixin {
  Sorting _sorting = Sorting.difficulty;
  TabController _controller;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: widget.gym.routes.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeSorting(Sorting sorting) {
    setState(() {
      _sorting = sorting;
    });
  }

  bool isChecked(Sorting sorting) {
    return sorting == _sorting;
  }

  void _addRoute() {
    getImage();
  }

  ImageProvider getCurrentImage() {
    if (_image != null) {
      return FileImage(_image);
    } else {
      return FileImage(File('gym-placeholder.jpg'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gym.name),
        actions: <Widget>[
          PopupMenuButton<Sorting>(
            onSelected: changeSorting,
            itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: Text(S.of(context).sortRoutes),

                  ),
                  PopupMenuDivider(),
                  CheckedPopupMenuItem<Sorting>(
                    value: Sorting.difficulty,
                    checked: isChecked(Sorting.difficulty),
                    child: Text(S.of(context).difficulty),
                  ),
                  CheckedPopupMenuItem<Sorting>(
                    value: Sorting.newestFirst,
                    checked: isChecked(Sorting.newestFirst),
                    child: Text(S.of(context).newestFirst),
                  ),
                ],
          ),
        ],
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: 18),
          controller: _controller,
          isScrollable: true,
          indicator: UnderlineTabIndicator(),
          tabs: widget.gym.routes.map<Tab>((ClimbingRoute route) {
            return Tab(text: route.grade.toString());
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: widget.gym.routes.map<Widget>((ClimbingRoute route) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Container(
              foregroundDecoration: BoxDecoration(
                image: DecorationImage(
                    image: getCurrentImage(), fit: BoxFit.cover),
              ),
              key: Key(route.id),
              padding: const EdgeInsets.all(0.0),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: S.of(context).addNewRoute,
        backgroundColor: Colors.redAccent,
        label: Text(S.of(context).addRoute.toUpperCase()),
        onPressed: _addRoute,
      ),
    );
  }
}
