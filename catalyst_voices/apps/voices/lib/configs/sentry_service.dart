import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryService {
  const SentryService._();

  static Future<void> init(
    Widget app,
  ) async {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = BuildConfig.sentryDsn
          ..environment = BuildConfig.sentryEnvironment
          ..tracesSampleRate = 1.0
          ..profilesSampleRate = 1.0
          ..attachScreenshot = true
          ..screenshotQuality = SentryScreenshotQuality.low
          ..attachViewHierarchy = true;
      },
      appRunner: () => runApp(app),
    );
  }
}
