import 'package:climbing/models/coordinates.dart';
import 'package:vibrate/vibrate.dart';

import 'enums/sign_in_provider_enum.dart';
import 'models/gym.dart';
import 'models/user_authority.dart';

typedef UpdateUserCallback = void Function(
    {String token,
    String googleId,
    String name,
    String email,
    String nickname,
    String pictureId,
    String photoPath,
    String appleIdCredentialUser,
    List<UserAuthority> authorities,
    Set<String> bookmarks});

typedef FeedbackCallback = void Function(FeedbackType type);

typedef SignInCallback = Future<bool> Function(SignInProvider);

typedef SignOutCallback = void Function();

typedef UpdateCoordinatesCallback = void Function(Coordinates);

typedef UpdateGymCallback = void Function(Gym, {String id, bool visible});

typedef FetchGymsCallback = Future<void> Function({bool force});
