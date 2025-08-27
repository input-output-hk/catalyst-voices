import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';

abstract interface class ReportingService {
  Future<void> init({
    required ReportingServiceConfig config,
    required ValueGetter<FutureOr<void>> appRunner,
  });

  Future<void> reportingAs(Account? account);
}
