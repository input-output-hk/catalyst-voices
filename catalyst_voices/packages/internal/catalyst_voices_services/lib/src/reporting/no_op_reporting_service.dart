import 'dart:async' as async show runZonedGuarded;
import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final class NoOpReportingService implements ReportingService {
  const NoOpReportingService();

  @override
  http.Client? buildHttpClient() => null;

  @override
  NavigatorObserver? buildNavigatorObserver() => null;

  @override
  Future<void> init({required ReportingServiceConfig config}) async {}

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
