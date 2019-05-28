import 'package:climbing/classes/user.dart';
import 'package:climbing/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DrawerMenu extends StatelessWidget {
  final User user;
  final Function signOut;
  final Function signIn;
  final Function register;
  final Function openSettings;

  const DrawerMenu(this.user, this.signOut, this.signIn, this.register, this.openSettings);

  @override
  Widget build(BuildContext context) {
    final List<Widget> menuItems = [];

    if (user == null) {
      // Anonymous
      menuItems.add(DrawerHeader(
          child: Column(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(S.of(context).signIn),
              onTap: signIn),
          ListTile(
              leading: Icon(Icons.person_add),
              title: Text(S.of(context).register),
              onTap: register)
        ],
      )));
    } else {
      // Signed in
      menuItems.add(UserAccountsDrawerHeader(
        accountName: Text(user.name),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user.getPictureUrl()),
        ),
        margin: EdgeInsets.zero,
      ));
      // Sign out option
      menuItems.add(ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text(S.of(context).signOut),
          onTap: signOut));
    }

    menuItems.add(ListTile(
        leading: Icon(Icons.settings),
        title: Text(S.of(context).settings),
        onTap: openSettings));

    return Drawer(
      child: Column(
        children: menuItems,
      ),
    );
  }
}
