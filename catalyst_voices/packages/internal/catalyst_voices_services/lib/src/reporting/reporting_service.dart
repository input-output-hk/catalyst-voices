import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

abstract interface class ReportingService {
  NavigatorObserver buildNavigatorObserver();

  Future<void> init({
    required ReportingServiceConfig config,
    required ValueGetter<FutureOr<void>> appRunner,
  });

  Future<void> reportingAs(Account? account);
}
