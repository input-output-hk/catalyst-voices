import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart' show SentryConfig;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryService {
  static bool get shouldEnable => kReleaseMode || kProfileMode;

  const SentryService._();

  static Future<void> init(
    Widget app, {
    required SentryConfig config,
  }) async {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = config.dsn
          ..environment = config.environment
          ..tracesSampleRate = config.tracesSampleRate
          ..profilesSampleRate = config.profilesSampleRate
          ..enableAutoSessionTracking = config.enableAutoSessionTracking
          ..attachScreenshot = config.attachScreenshot
          ..attachViewHierarchy = config.attachViewHierarchy
          ..screenshotQuality = SentryScreenshotQuality.low
          ..debug = config.debug
          ..diagnosticLevel = SentryLevel.fromName(config.diagnosticLevel)
          ..release = config.release
          ..dist = config.dist;
      },
      appRunner: () => runApp(app),
    );
  }
}
