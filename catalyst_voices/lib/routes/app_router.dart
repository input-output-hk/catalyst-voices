import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'rootNavigatorKey',
  );

  static GoRouter init({
    List<RouteGuard> guards = const [],
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: Routes.initialLocation,
      redirect: (context, state) async => _guard(context, state, guards),
      observers: [
        SentryNavigatorObserver(),
      ],
      routes: Routes.routes,
      // always true. We're deciding whether to print
      // them or not in LoggingService
      debugLogDiagnostics: true,
    );
  }

  static FutureOr<String?> _guard(
    BuildContext context,
    GoRouterState state,
    List<RouteGuard> guards,
  ) async {
    for (final guard in guards) {
      final redirect = await guard.redirect(context, state);

      if (redirect != null) {
        return redirect;
      }
    }

    return null;
  }
}
