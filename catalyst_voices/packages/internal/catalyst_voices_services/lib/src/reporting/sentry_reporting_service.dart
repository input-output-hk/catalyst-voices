import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/reporting/reporting_service.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryReportingService implements ReportingService {
  const SentryReportingService();

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
          ..attachScreenshot = config.attachScreenshot
          ..screenshotQuality = SentryScreenshotQuality.low
          ..attachViewHierarchy = config.attachViewHierarchy
          ..debug = config.debug
          ..diagnosticLevel = SentryLevel.fromName(config.diagnosticLevel);
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
