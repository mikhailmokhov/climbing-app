import 'package:climbing/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:climbing/generated/i18n.dart';

void main() {
  testWidgets('Drawer menu', (WidgetTester tester) async {
    bool flag = false;
    await tester.pumpWidget(new MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            localizationsDelegates: [S.delegate],
            supportedLocales: S.delegate.supportedLocales,
            home: DrawerMenu('Alex Honnold', 'alex.honnold@gmail.com',
                AssetImage('images/honnold.png'), () {
              flag = true;
            }))));
    expect(find.text('Alex Honnold'), findsOneWidget);
    expect(find.text('alex.honnold@gmail.com'), findsOneWidget);
    await tester.tap(find.text('Clear cache'));
    expect(flag, true);
  });
}
