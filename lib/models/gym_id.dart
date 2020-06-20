import 'package:climbing/enums/gyms_provider.dart';
import 'package:flutter/foundation.dart';

@immutable
class GymId {
  const GymId(this.id, this.provider);

  final String id;
  final GymProvider provider;
}
