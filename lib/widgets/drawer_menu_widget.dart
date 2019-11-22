
import 'package:climbing/classes/grade_scale_class.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import '../main.dart';
import 'profile_drawer_header_widget.dart';

class DrawerMenu extends StatefulWidget {
  final User user;
  final Function signOut;
  final Function signIn;
  final Function register;
  final Function openSettings;

  const DrawerMenu(
      this.user, this.signOut, this.signIn, this.register, this.openSettings,
      {Key key})
      : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  GradeScales _gradeScale = GradeScales.YSD;

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnItems = [];

    columnItems.add(AccountDrawerHeader(
      user: widget.user,
      onSignOutTap: widget.signOut,
      signIn: widget.signIn,
    ));

    // Browse gyms
//    columnItems.add(ListTile(
//        title: Text(S.of(context).browseGyms),
//        trailing: Icon(Icons.arrow_forward_ios),
//        onTap: () {
//          Navigator.of(context).pop();
//          Navigator.pushNamed(context, '/gymslist');
//        }));

    // Grading system
    columnItems.add(ListTile(
        trailing: DropdownButton<GradeScales>(
          value: _gradeScale,
          onChanged: (GradeScales newValue) {
            setState(() {
              _gradeScale = newValue;
            });
            if (canVibrate) Vibrate.feedback(FeedbackType.selection);
          },
          items: <GradeScales>[
            GradeScales.YSD,
            GradeScales.French,
          ].map<DropdownMenuItem<GradeScales>>((GradeScales scale) {
            String name;
            switch (scale) {
              case GradeScales.YSD:
                name = S.of(context).yosemite;
                break;
              case GradeScales.French:
                name = S.of(context).french;
                break;
              case GradeScales.UIAA:
                name = S.of(context).uiaa;
                break;
              case GradeScales.UK:
                name = S.of(context).uk;
                break;
              case GradeScales.Australian:
                name = S.of(context).australian;
                break;
            }
            return DropdownMenuItem<GradeScales>(
              value: scale,
              child: Text(name),
            );
          }).toList(),
        ),
        title: Text(S.of(context).gradingSystem),
        onTap: widget.openSettings));

    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: columnItems,
      ),
    );
  }
}

