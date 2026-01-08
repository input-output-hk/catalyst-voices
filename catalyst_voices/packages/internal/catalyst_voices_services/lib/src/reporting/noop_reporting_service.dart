import 'dart:async' as async show runZonedGuarded;
import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/reporting/database_logging_interceptor.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

final class NoopReportingService implements ReportingService {
  const NoopReportingService();

  @override
  QueryInterceptor? buildDbInterceptor({required String databaseName}) {
    return DatabaseLoggingInterceptor(databaseName: databaseName);
  }

  @override
  NavigatorObserver? buildNavigatorObserver() => null;

  @override
  Future<void> init({required ReportingServiceConfig config}) async {}

  @override
  void registerDio(Dio dio) {}

  @override
  Future<void> reportingAs(Account? account) async {}

  @override
  R? runZonedGuarded<R>(
    ValueGetter<R> body,
    void Function(Object error, StackTrace stack) onError, {
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
  }) {
    return async.runZonedGuarded(
      body,
      onError,
      zoneValues: zoneValues,
      zoneSpecification: zoneSpecification,
    );
  }

  @override
  Widget wrapApp(Widget app) => app;
}
