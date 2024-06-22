import 'package:catalyst_voices/routes/home_page_route.dart' as home_route;
import 'package:catalyst_voices/routes/login_page_route.dart' as login_route;
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'rootNavigatorKey',
  );

  static GoRouter init({
    required AuthenticationBloc authenticationBloc,
  }) {
    return GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      initialLocation: _isWeb(),
      refreshListenable: AppRouterRefreshStream(authenticationBloc.stream),
      redirect: (context, state) => _guard(authenticationBloc, state),
      observers: [
        SentryNavigatorObserver(),
      ],
      routes: _routes(),
    );
  }

  static String? _guard(
    AuthenticationBloc authenticationBloc,
    GoRouterState state,
  ) {
    // Always return home route that defaults to coming soon page.
    return home_route.homePath;
  }

  static String? _isWeb() {
    if (kIsWeb) {
      return Uri.base.toString().replaceFirst(Uri.base.origin, '');
    } else {
      return null;
    }
  }

  static List<RouteBase> _routes() {
    return [
      ...login_route.$appRoutes,
      ...home_route.$appRoutes,
    ];
  }
}
