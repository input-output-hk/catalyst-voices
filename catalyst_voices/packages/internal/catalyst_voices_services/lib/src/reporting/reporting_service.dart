import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:drift/drift.dart' show QueryInterceptor;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract interface class ReportingService {
  QueryInterceptor? buildDbInterceptor({
    required String databaseName,
  });

  http.Client? buildHttpClient();

  NavigatorObserver? buildNavigatorObserver();

  Future<void> init({
    required ReportingServiceConfig config,
  });

  Future<void> reportingAs(Account? account);

  R? runZonedGuarded<R>(
    ValueGetter<R> body,
    void Function(Object error, StackTrace stack) onError, {
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
  });

  Widget wrapApp(Widget app);
}
