import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing/classes/api.dart';
import 'package:climbing/classes/user_class.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:climbing/sign_in/sign_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import 'edit_profile_widget.dart';

const double _kAccountDetailsHeight = 49.0;

class AccountDrawerHeader extends StatefulWidget {
  final Function onNameEmailTap;
  final Function onSignOutTap;
  final Function signedIn;
  final Function onEditAccountTap;
  final bool isAppleSignInAvailable;
  final bool isGoogleSignInAvailable;
  final User user;
  final Api api;
  final Future<bool> canVibrate;

  const AccountDrawerHeader({
    Key key,
    this.onNameEmailTap,
    @required this.onSignOutTap,
    @required this.user,
    @required this.signedIn,
    this.onEditAccountTap,
    @required this.isAppleSignInAvailable,
    @required this.isGoogleSignInAvailable,
    @required this.api,
    @required this.canVibrate,
  }) : super(key: key);

  @override
  _AccountDrawerHeaderState createState() => _AccountDrawerHeaderState();
}

class _AccountDrawerHeaderState extends State<AccountDrawerHeader> {
  updateProfile(String name, String userName) {
    setState(() {
      this.widget.user.name = name;
      this.widget.user.username = userName;
    });
  }

  editAccount() {
    widget.canVibrate.then((value) {
      Vibrate.feedback(FeedbackType.selection);
    });
    Navigator.push(
        context,
        MaterialPageRoute<DismissDialogAction>(
          builder: (BuildContext context) => EditAccount(
            user: this.widget.user,
            updateProfile: updateProfile,
          ),
          fullscreenDialog: true,
        ));
  }

  signOut() {
    this.widget.onSignOutTap();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> elements = [];
    List<Widget> headerRows = [];
    if (this.widget.user == null) {
      // Sign In button
      elements.add(PositionedDirectional(
        end: 10.0,
        child: OutlineButton.icon(
            label: Text(S.of(context).signInSignUp,
                style: TextStyle(
                    color: Theme.of(context).primaryIconTheme?.color)),
            icon: Icon(Icons.account_circle,
                color: Theme.of(context).primaryIconTheme?.color),
            onPressed: () {
              widget.canVibrate.then((value) {
                Vibrate.feedback(FeedbackType.light);
              });
              showDialog(
                context: context,
                builder: (BuildContext passedContext) => SignInDialog(
                    signedIn: widget.signedIn,
                    isAppleSignInAvailable: widget.isAppleSignInAvailable,
                    isGoogleSignInAvailable: widget.isGoogleSignInAvailable,
                    api: widget.api),
              );
            }),
      ));
    } else {
      // Avatar
      elements.add(Positioned(
        top: 0.0,
        child: Semantics(
          onTap: editAccount,
          explicitChildNodes: true,
          child: SizedBox(
            width: 77.0,
            height: 77.0,
            child: InkWell(
              onTap: editAccount,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    this.widget.user.getPictureUrl()),
              ),
            ),
          ),
        ),
      ));

      // Sign Out button
      elements.add(PositionedDirectional(
        end: 10.0,
        child: OutlineButton(
            onPressed: () {
              widget.canVibrate.then((value) {
                Vibrate.feedback(FeedbackType.light);
              });
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(S.of(context).signOutQuestion),
                    actions: <Widget>[
                      RaisedButton(
                        textColor: Colors.white,
                        child: Text(S.of(context).YES),
                        onPressed: () {
                          this.widget.onSignOutTap();
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
              style: Theme.of(context).primaryTextTheme.body2,
              child: Text(S.of(context).signOut),
            )),
      ));

      // Account name, username and edit account button
      headerRows.add(
        SizedBox(
          height: _kAccountDetailsHeight,
          child: Row(
            children: <Widget>[
              // Account name/username
              InkWell(
                onTap: editAccount,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: DefaultTextStyle(
                            style: Theme.of(context).primaryTextTheme.body2,
                            overflow: TextOverflow.ellipsis,
                            child: Text(this.widget.user.name.isEmpty
                                ? ''
                                : this.widget.user.name),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: DefaultTextStyle(
                          style: Theme.of(context).primaryTextTheme.body1,
                          overflow: TextOverflow.ellipsis,
                          child: Text(this.widget.user.username.isEmpty
                              ? ''
                              : this.widget.user.username),
                        ),
                      )
                    ]),
              ),
              // Edit account button
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Tooltip(
                    message: S.of(context).editProfile,
                    child: SizedBox(
                      width: 50,
                      child: OutlineButton(
                          shape: CircleBorder(),
                          onPressed: editAccount,
                          child: Icon(
                            Icons.mode_edit,
                            color:
                                Theme.of(context).primaryTextTheme.body2.color,
                            size: 20,
                          )),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      );
    }

    // Top row with avatar and Sign In/Out buttons
    headerRows.insert(
        0,
        Expanded(
          child: Stack(children: elements),
        ));

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsetsDirectional.only(
          top: 15.0, start: 17.0, bottom: 9.0, end: 7.0),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: headerRows,
        ),
      ),
    );
  }
}
