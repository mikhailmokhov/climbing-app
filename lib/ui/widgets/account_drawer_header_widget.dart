import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing/enums/sign_in_provider_enum.dart';
import 'package:climbing/models/app_state.dart';
import 'package:climbing/generated/l10n.dart';
import 'package:climbing/screens/edit_profile_screen.dart';
import 'package:climbing/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import '../../typedefs.dart';

const double _kAccountDetailsHeight = 49.0;

class AccountDrawerHeader extends StatelessWidget {
  const AccountDrawerHeader(
      {Key key,
      @required this.signOut,
      @required this.appState,
      @required this.signIn,
      @required this.updateUser,
      @required this.feedback})
      : super(key: key);

  final Function(SignInProvider) signIn;
  final SignOutCallback signOut;
  final UpdateUserCallback updateUser;
  final AppState appState;
  final FeedbackCallback feedback;

  @override
  Widget build(BuildContext context) {
    void _editAccount() {
      feedback(FeedbackType.selection);
      Navigator.pushNamed(context, EditProfileScreen.routeName);
    }

    final List<Widget> topRowItems = <Widget>[];
    final List<Widget> rows = <Widget>[];
    if (appState.user == null) {
      // Sign In button
      topRowItems.add(PositionedDirectional(
        end: 10.0,
        top: 0.0,
        child: OutlineButton.icon(
            label: Text(S.of(context).signInSignUp,
                style: TextStyle(
                    color: Theme.of(context).primaryIconTheme?.color)),
            icon: Icon(Icons.account_circle,
                color: Theme.of(context).primaryIconTheme?.color),
            onPressed: () {
              feedback(FeedbackType.light);
              Utils.showSignInDialog(
                  context, appState.signInProviderSet, signIn);
            }),
      ));
    } else {
      // Avatar
      topRowItems.add(Positioned(
        top: 0.0,
        left: 0.0,
        child: Semantics(
          onTap: _editAccount,
          explicitChildNodes: true,
          child: SizedBox(
            width: 77.0,
            height: 77.0,
            child: InkWell(
              onTap: _editAccount,
              child: CircleAvatar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage:
                    CachedNetworkImageProvider(appState.user.getPictureUrl()),
              ),
            ),
          ),
        ),
      ));

      // Sign Out button
      topRowItems.add(PositionedDirectional(
        end: 10.0,
        top: 0.0,
        child: OutlineButton(
            onPressed: () {
              feedback(FeedbackType.light);
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(S.of(context).signOutQuestion),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text(S.of(context).YES),
                        onPressed: () {
                          signOut();
                          Navigator.pop(context);
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
            },
            child: DefaultTextStyle(
              style: Theme.of(context).primaryTextTheme.bodyText1,
              child: Text(S.of(context).signOut),
            )),
      ));

      // Account name, username and edit account button
      rows.add(
        SizedBox(
          height: _kAccountDetailsHeight,
          child: Row(
            children: <Widget>[
              // Account name/username
              Expanded(
                child: Container(
                  child: InkWell(
                    onTap: _editAccount,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: DefaultTextStyle(
                                softWrap: false,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1,
                                overflow: TextOverflow.fade,
                                child: Text(appState.user.name.isEmpty
                                    ? ''
                                    : appState.user.name),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: DefaultTextStyle(
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyText1,
                              child: Text(appState.user.nickname.isEmpty
                                  ? ''
                                  : appState.user.nickname),
                            ),
                          )
                        ]),
                  ),
                ),
              ),
              // Edit account button
              Container(
                child: Tooltip(
                  message: S.of(context).editProfile,
                  child: SizedBox(
                    width: 50,
                    child: OutlineButton(
                        shape: const CircleBorder(),
                        onPressed: _editAccount,
                        child: Icon(
                          Icons.mode_edit,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1
                              .color,
                          size: 20,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Top row with avatar and Sign In/Out buttons
    rows.insert(
        0,
        Expanded(
          child: Stack(children: topRowItems),
        ));

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      padding: const EdgeInsetsDirectional.only(
          top: 15.0, start: 15.0, bottom: 9.0, end: 0.0),
      child: SafeArea(
        bottom: false,
        child: Container(
          child: Column(
            children: rows,
          ),
        ),
      ),
    );
  }
}
