// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:climbing/app.dart';
import 'package:climbing/repositories/user_repository.dart';
import 'package:climbing/services/apple_sign_in_service.dart';
import 'package:climbing/services/connectivity_service.dart';
import 'package:climbing/services/haptic_feedback_service.dart';
import 'package:climbing/services/location_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ClimbingApp(
      userRepository: UserRepository(
        storage: const FlutterSecureStorage(),
      ),
      appleSignInService: AppleSignInService(),
      hapticFeedbackService: HapticFeedbackService(),
      connectivityService: ConnectivityService(),
      locationService: LocationService(),
    ),);
  });
}
