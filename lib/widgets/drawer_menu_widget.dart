import 'package:climbing/models/sign_in_provider_enum.dart';
import 'package:climbing/services/api_service.dart';
import 'package:climbing/classes/grade_scale_class.dart';
import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import 'profile_drawer_header_widget.dart';

class DrawerMenu extends StatefulWidget {
  final User user;
  final Function signOut;
  final Function(SignInProvider, BuildContext context) signIn;
  final Function register;
  final Function openSettings;
  final List<SignInProvider> signInProviderList;
  final ApiService api;
  final Future<bool> canVibrate;
  final Future<bool> Function(User) updateUser;

  const DrawerMenu({
    @required this.user,
    @required this.signOut,
    @required this.signIn,
    @required this.register,
    @required this.openSettings,
    @required this.signInProviderList,
    @required this.api,
    @required this.canVibrate,
    @required this.updateUser,
    Key key,
  }) : super(key: key);

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
      signInProviderList: this.widget.signInProviderList,
      api: widget.api,
      canVibrate: widget.canVibrate,
      updateUser: this.widget.updateUser,
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
            widget.canVibrate.then((value) {
              Vibrate.feedback(FeedbackType.selection);
            });
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
