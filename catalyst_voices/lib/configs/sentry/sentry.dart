import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryService {
  const SentryService._();

  static Future<void> captureException(
    Object error,
    StackTrace stackTrace,
  ) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  }

  /// Never call it in release mode.
  /// It is only for development and testing.
  static Future<void> crash() async {
    try {
      throw Exception('Capture Exception!');
    } catch (error, stackTrace) {
      await SentryService.captureException(error, stackTrace);
    }
  }

  static Future<void> init(
    Widget app,
  ) async {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = AppConfig.sentryDsn
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
