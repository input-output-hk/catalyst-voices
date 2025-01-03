import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'rootNavigatorKey',
  );

  static GoRouter init({
    String? initialLocation,
    List<RouteGuard> guards = const [],
    Listenable? refreshListenable,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation ?? Routes.initialLocation,
      redirect: (context, state) async => _guard(context, state, guards),
      observers: [
        SentryNavigatorObserver(),
      ],
      refreshListenable: refreshListenable,
      routes: Routes.routes,
      // always true. We're deciding whether to print
      // them or not in LoggingService
      debugLogDiagnostics: true,
    );
  }

  static Future<String?> _guard(
    BuildContext context,
    GoRouterState state,
    List<RouteGuard> guards,
  ) async {
    for (final guard in guards) {
      final location = await guard.redirect(context, state);
      if (location != null) {
        return location;
      }
    }

    return null;
  }
}
