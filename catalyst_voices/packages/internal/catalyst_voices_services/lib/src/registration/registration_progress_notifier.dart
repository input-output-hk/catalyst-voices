import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';

final class RegistrationProgressNotifier
    extends ValueNotifier<RegistrationProgress> {
  RegistrationProgressNotifier([
    super.value = const RegistrationProgress(),
  ]);

  void clear() {
    value = const RegistrationProgress();
  }
}
