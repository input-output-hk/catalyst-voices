import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/reporting/reporting_service.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryReportingService implements ReportingService {
  const SentryReportingService();

  @override
  NavigatorObserver buildNavigatorObserver() {
    return SentryNavigatorObserver();
  }

  @override
  Future<void> init({
    required ReportingServiceConfig config,
    required ValueGetter<FutureOr<void>> appRunner,
  }) async {
    await SentryFlutter.init(
      (options) {
        if (config is! SentryConfig) {
          return;
        }

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
      appRunner: appRunner,
    );
  }

  @override
  Future<void> reportingAs(Account? account) async {
    assert(Sentry.isEnabled, 'Sentry not enabled');

    await Sentry.configureScope((scope) {
      final user = account != null
          ? SentryUser(
              id: account.catalystId.toUri().toString(),
              username: account.catalystId.username,
              data: {
                'publicStatus': account.publicStatus.toString(),
              },
            )
          : null;
      return scope.setUser(user);
    });
  }
}
