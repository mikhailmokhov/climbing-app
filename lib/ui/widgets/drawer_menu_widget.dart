import 'package:climbing/models/app_state.dart';
import 'package:climbing/typedefs.dart';
import 'package:flutter/material.dart';

import 'account_drawer_header_widget.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    @required this.appState,
    @required this.signOut,
    @required this.signIn,
    @required this.updateUser,
    @required this.feedback,
    Key key,
  }) : super(key: key);

  final AppState appState;
  final SignOutCallback signOut;
  final SignInCallback signIn;
  final UpdateUserCallback updateUser;
  final FeedbackCallback feedback;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AccountDrawerHeader(
            appState: appState,
            signOut: signOut,
            signIn: signIn,
            updateUser: updateUser,
            feedback: feedback,
          )
        ],
      ),
    );
  }
}
