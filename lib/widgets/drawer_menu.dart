import 'package:climbing/generated/i18n.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final String accountName;
  final String accountEmail;
  final ImageProvider accountPicture;
  final Function clearCache;

  const DrawerMenu(this.accountName, this.accountEmail, this.accountPicture,
      this.clearCache);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: accountPicture,
            ),
            margin: EdgeInsets.zero,
          ),
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListTile(
                  trailing: const Icon(Icons.delete_sweep),
                  title: Text(S.of(context).drawerMenu_clearCache),
                  onTap: () {
                    clearCache();
                  })),
        ],
      ),
    );
  }
}
