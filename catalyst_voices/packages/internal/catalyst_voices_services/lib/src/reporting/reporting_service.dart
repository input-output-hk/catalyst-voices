import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:drift/drift.dart' show QueryInterceptor;
import 'package:flutter/material.dart';

abstract interface class ReportingService {
  QueryInterceptor? buildDbInterceptor({
    required String databaseName,
  });

  NavigatorObserver? buildNavigatorObserver();

  Future<void> init({
    required ReportingServiceConfig config,
  });

  void registerDio(Dio dio);

  Future<void> reportingAs(Account? account);

  R? runZonedGuarded<R>(
    ValueGetter<R> body,
    void Function(Object error, StackTrace stack) onError, {
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
  });

  Widget wrapApp(Widget app);
}
