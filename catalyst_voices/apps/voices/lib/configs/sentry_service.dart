import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart' show SentryConfig;
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryService {
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
          ..attachScreenshot = config.attachScreenshot
          ..screenshotQuality = SentryScreenshotQuality.low
          ..attachViewHierarchy = config.attachViewHierarchy
          ..debug = config.debug
          ..diagnosticLevel = SentryLevel.fromName(config.diagnosticLevel);
      },
      appRunner: () => runApp(app),
    );
  }
}
