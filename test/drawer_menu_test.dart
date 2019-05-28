import 'package:climbing/classes/user.dart';
import 'package:climbing/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:climbing/generated/i18n.dart';

void main() {
  const String UUID = 'IBUUYU65viu*&kjlhbuKJHG';
  const String NAME = 'Александр Хоннолд';
  const String EMAIL = 'alex.honnold@gmail.com';

  testWidgets('Drawer signed in', (WidgetTester tester) async {
    final User user = User(UUID, NAME, EMAIL);
    bool userSignedIn = true;
    await tester.pumpWidget(new MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            localizationsDelegates: [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
            home: DrawerMenu(user, () {
              userSignedIn = false;
            }, () {}, () {}, () {}))));
    expect(find.text(NAME), findsOneWidget);
    expect(find.text(EMAIL), findsOneWidget);
    await tester.tap(find.text('Sign Out'));
    expect(userSignedIn, false);
  });

  testWidgets('Drawer sign out', (WidgetTester tester) async {
    final User user = null;
    bool userSignedIn = false;
    await tester.pumpWidget(new MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            localizationsDelegates: [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
            home: DrawerMenu(user, () {}, () {
              userSignedIn = true;
            }, () {}, () {}))));
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    await tester.tap(find.text('Sign In'));
    expect(userSignedIn, true);
  });
}
