import 'package:climbing/repositories/user_repository.dart';
import 'package:climbing/services/apple_sign_in_service.dart';
import 'package:climbing/services/connectivity_service.dart';
import 'package:climbing/services/haptic_feedback_service.dart';
import 'package:climbing/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ClimbingApp(
      userRepository: UserRepository(
        storage: const FlutterSecureStorage(),
      ),
      appleSignInService: AppleSignInService(),
      hapticFeedbackService: HapticFeedbackService(),
      connectivityService: ConnectivityService(),
      locationService: LocationService(),
    ),
  );
}
