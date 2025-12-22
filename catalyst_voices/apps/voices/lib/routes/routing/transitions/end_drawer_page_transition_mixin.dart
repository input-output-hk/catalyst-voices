import 'dart:async';

import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EndDrawerRouteStackConfig {
  final String route;
  final List<EndDrawerRouteStackConfig> subRoutes;

  const EndDrawerRouteStackConfig({
    required this.route,
    this.subRoutes = const [],
  });

  /// Builds a list of routes that need to be pushed based on the current path.
  ///
  /// For a path like `/myactions/proposal_approval`, this returns:
  /// ['/myactions', '/myactions/proposal_approval']
  List<String> buildRouteStack(String currentPath) {
    final routesToPush = <String>[];
    _collectMatchingRoutes(currentPath, routesToPush);
    return routesToPush;
  }

  void _collectMatchingRoutes(String currentPath, List<String> routesToPush) {
    if (!currentPath.contains(route)) return;

    routesToPush.add(route);

    // Check if any sub-route matches
    for (final subRouteConfig in subRoutes) {
      if (currentPath.contains(subRouteConfig.route)) {
        subRouteConfig._collectMatchingRoutes(currentPath, routesToPush);
        return;
      }
    }
  }
}

/// A mixin that provides a drawer-like page transition for [ShellRouteData].
///
/// This creates a transparent page with a Scaffold that automatically opens
/// its endDrawer, keeping the previous page visible underneath.

/// Use this when you want the shell route to display its content in
/// an end drawer, allowing nested routes to change the drawer content.
mixin EndDrawerShellPageTransitionMixin on ShellRouteData {
  static const transitionPageName = 'EndDrawerShellPageTransition';

  /// Configuration that defines how the route stack should be built.
  EndDrawerRouteStackConfig get routeStackConfig;

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      name: transitionPageName,
      arguments: <String, String>{
        ...state.pathParameters,
        ...state.uri.queryParameters,
      },
      restorationId: state.pageKey.value,
      opaque: false,
      barrierDismissible: true,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      child: _EndDrawerScaffold(
        drawerContent: builder(context, state, navigator),
        routeStackConfig: routeStackConfig,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    );
  }
}

class _EndDrawerScaffold extends StatefulWidget {
  final Widget drawerContent;
  final EndDrawerRouteStackConfig routeStackConfig;

  const _EndDrawerScaffold({
    required this.drawerContent,
    required this.routeStackConfig,
  });

  @override
  State<_EndDrawerScaffold> createState() => _EndDrawerScaffoldState();
}

class _EndDrawerScaffoldState extends State<_EndDrawerScaffold> {
  // The duration comes from Flutter's DrawerController which uses
  // `_kBaseSettleDuration = Duration(milliseconds: 246)`.
  // See: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/drawer.dart
  final _kBaseSettleDuration = const Duration(milliseconds: 246);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasPopped = false;
  bool _wasOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: widget.drawerContent,
      drawerEnableOpenDragGesture: false,
      onEndDrawerChanged: _onEndDrawerChanged,
      body: const SizedBox.shrink(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final router = GoRouter.of(context);
      final currentConfiguration = router.routerDelegate.currentConfiguration;
      final currentPath = currentConfiguration.last.matchedLocation;
      final queryString = router.routeInformationProvider.value.uri.query;

      if (currentConfiguration.matches.length > 1) {
        final requiredRoutes = _buildRouteStack(currentPath, queryString);
        final existingPaths = currentConfiguration.matches
            .map((match) => match.matchedLocation)
            .toList();
        final missingRoutes = requiredRoutes.where((route) {
          final routePath = Uri.parse(route).path;
          return !existingPaths.contains(routePath);
        }).toList();

        if (missingRoutes.isNotEmpty) {
          _pushRoutesSequentially(router, requiredRoutes);
        }

        _scaffoldKey.currentState?.openEndDrawer();
      } else {
        router.go(Routes.initialLocation);
        final routesToPush = _buildRouteStack(currentPath, queryString);
        _pushRoutesSequentially(router, routesToPush);
      }
    });
  }

  List<String> _buildRouteStack(String currentPath, String queryString) {
    final routes = widget.routeStackConfig.buildRouteStack(currentPath);
    if (routes.isEmpty || queryString.isEmpty) return routes;

    // Add query parameters to all routes
    return routes.map((route) => '$route?$queryString').toList();
  }

  Future<void> _onEndDrawerChanged(bool isOpened) async {
    if (isOpened) {
      _wasOpened = true;
      return;
    }

    // Only pop when drawer closes after being opened
    if (_wasOpened && !_hasPopped) {
      _hasPopped = true;
      await _waitForDrawerDismissed();
    }
  }

  /// Pushes routes sequentially, each in its own post frame callback.
  void _pushRoutesSequentially(GoRouter router, List<String> routes) {
    if (routes.isEmpty) return;

    void pushNext(int index) {
      if (index >= routes.length) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(router.push(routes[index]));
        pushNext(index + 1);
      });
    }

    pushNext(0);
  }

  Future<void> _waitForDrawerDismissed() async {
    // Wait for the drawer close animation to complete.
    await Future<void>.delayed(_kBaseSettleDuration);

    if (!mounted) return;

    var isShell = false;

    Navigator.of(context).popUntil((predicate) {
      if (predicate.settings.name == EndDrawerShellPageTransitionMixin.transitionPageName) {
        isShell = true;
        return false;
      }

      return isShell;
    });
  }
}
