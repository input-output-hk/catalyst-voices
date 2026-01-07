import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/reporting/reporting_service.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:sentry_drift/sentry_drift.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';

final class SentryReportingService implements ReportingService {
  const SentryReportingService();

  @override
  QueryInterceptor? buildDbInterceptor({required String databaseName}) {
    return SentryQueryInterceptor(databaseName: databaseName);
  }

  @override
  NavigatorObserver buildNavigatorObserver() {
    return SentryNavigatorObserver();
  }

  @override
  Future<void> init({
    required ReportingServiceConfig config,
  }) async {
    if (config is! SentryConfig) {
      throw ArgumentError('SentryReportingService supports only SentryConfig', 'config');
    }

    await SentryFlutter.init(
      (options) {
        options
          ..dsn = config.dsn
          ..environment = config.environment
          ..tracesSampleRate = config.tracesSampleRate
          ..profilesSampleRate = config.profilesSampleRate
          ..enableAutoSessionTracking = config.enableAutoSessionTracking
          ..enableTimeToFullDisplayTracing = config.enableTimeToFullDisplayTracing
          ..enableLogs = config.enableLogs
          ..attachScreenshot = config.attachScreenshot
          ..attachViewHierarchy = config.attachViewHierarchy
          ..screenshotQuality = SentryScreenshotQuality.low
          ..debug = config.debug
          ..diagnosticLevel = SentryLevel.fromName(config.diagnosticLevel)
          ..release = config.release
          ..dist = config.dist
          ..beforeSend = filterThirdPartyErrors
          ..addInAppInclude('catalyst')
          ..addInAppExclude('chrome-extension://')
          ..addInAppExclude('moz-extension://')
          ..addInAppExclude('safari-web-extension://');

        if (config.enableLogs) {
          options.addIntegration(LoggingIntegration());
        }
      },
    );
  }

  @override
  void registerDio(Dio dio) => dio.addSentry();

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

  @override
  R? runZonedGuarded<R>(
    ValueGetter<R> body,
    void Function(Object error, StackTrace stack) onError, {
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
  }) {
    final result = Sentry.runZonedGuarded(
      body,
      onError,
      zoneValues: zoneValues,
      zoneSpecification: zoneSpecification,
    );

    return result is R ? result : null;
  }

  @override
  Widget wrapApp(Widget app) => SentryWidget(child: app);

  /// Filters out errors originating from third-party browser extensions
  /// that don't involve our application code.
  ///
  /// This prevents noise from wallet extensions (e.g., Talisman, MetaMask)
  /// reporting their own internal errors that are unrelated to Catalyst Voices.
  ///
  /// Errors are kept if:
  /// - They originate from our app code (catalyst_* packages)
  /// - They occur during wallet interactions initiated by our app
  ///
  /// Errors are filtered if:
  /// - They only have browser extension frames (no app involvement)
  /// - They are pure third-party extension errors
  @visibleForTesting
  static FutureOr<SentryEvent?> filterThirdPartyErrors(
    SentryEvent event,
    Hint hint,
  ) {
    final exceptions = event.exceptions;
    if (exceptions == null || exceptions.isEmpty) {
      return event;
    }

    final containsAppFrames = exceptions.any((exception) {
      final stackTrace = exception.stackTrace;
      // If no stack trace, assume it's from our app to be safe
      if (stackTrace == null) return true;

      final frames = stackTrace.frames;
      if (frames.isEmpty) return false;

      // Check if ALL frames in this exception are from browser extensions
      final allFramesAreExtensions = frames.every((frame) {
        final absPath = (frame.absPath ?? '').toLowerCase();
        return absPath.contains('chrome-extension://') ||
            absPath.contains('moz-extension://') ||
            absPath.contains('safari-web-extension://');
      });

      // If all frames are from extensions, filter out this exception
      return !allFramesAreExtensions;
    });

    return containsAppFrames ? event : null;
  }
}
