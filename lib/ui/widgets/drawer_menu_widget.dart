import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/models/grade_scale.dart';
import 'package:climbing/models/user.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import 'account_drawer_header_widget.dart';

class DrawerMenu extends StatefulWidget {
  final User user;
  final Function signOut;
  final Function(SignInProvider) signIn;
  final Set<SignInProvider> signInProviderSet;
  final void Function() updateUserCallback;

  const DrawerMenu({
    @required this.user,
    @required this.signOut,
    @required this.signIn,
    @required this.signInProviderSet,
    @required this.updateUserCallback,
    Key key,
  }) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  GradeScales _gradeScale = GradeScales.YSD;
  bool _canVibrate = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnItems = [];

    columnItems.add(AccountDrawerHeader(
      user: widget.user,
      onSignOutTap: widget.signOut,
      signIn: widget.signIn,
      signInProviderSet: this.widget.signInProviderSet,
      updateUserCallback: this.widget.updateUserCallback,
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
            if (_canVibrate) Vibrate.feedback(FeedbackType.selection);
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
        title: Text(S.of(context).gradingSystem)));

    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: columnItems,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Vibrate.canVibrate.then((value) => _canVibrate = value);
  }
}
