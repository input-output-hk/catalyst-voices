import 'dart:async';

import 'package:catalyst_voices/pages/not_found/not_found_page.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A factory which builds instance of [GoRouter] for app.
///
/// Its using [Routes] as source for known and supported paths.
///
/// Injects Sentry integration.
abstract final class AppRouterFactory {
  /// Global root key of app navigation.
  ///
  /// Use only when you don't have access to [BuildContext] or you need to
  /// change route before navigator is built.
  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigatorKey');

  static GoRouter create({
    String? initialLocation,
    List<RouteGuard> guards = const [],
    Listenable? refreshListenable,
  }) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
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
      errorBuilder: (_, __) => const NotFoundPage(),
    );
  }

  /// Top-level guard implementation.
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
