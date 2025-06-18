import 'dart:async';

import 'package:catalyst_voices_services/src/logging/reporting/log_reporting_strategy.dart';
import 'package:logging/logging.dart' show LogRecord;
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryErrorsReportingStrategy implements LogReportingStrategy {
  const SentryErrorsReportingStrategy();

  @override
  void report(LogRecord log) {
    final error = log.error;
    if (error == null) {
      return;
    }

    if (!Sentry.isEnabled) {
      return;
    }

    unawaited(
      Sentry.captureException(
        error,
        stackTrace: log.stackTrace,
        hint: Hint.withMap({
          'logger': log.loggerName,
          'message': log.message,
        }),
      ),
    );
  }
}
