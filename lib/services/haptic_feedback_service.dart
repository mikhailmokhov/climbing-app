import 'package:vibrate/vibrate.dart';

class HapticFeedbackService {
  HapticFeedbackService() {
    Vibrate.canVibrate.then((bool value) {
      _canVibrate = value;
    });
  }

  bool _canVibrate;

  void feedback(FeedbackType type) {
    if (_canVibrate) {
      Vibrate.feedback(type);
    }
  }
}
