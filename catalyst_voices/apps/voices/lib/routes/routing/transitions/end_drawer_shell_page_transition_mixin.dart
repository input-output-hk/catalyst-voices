import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Configuration for building a hierarchical route stack for drawer navigation.
///
/// This class defines the structure of routes and their sub-routes,
/// enabling the drawer to properly manage navigation state.
class EndDrawerRouteStackConfig implements DrawerPageScaffoldRouteStackResolver {
  /// The route path for this configuration node.
  final String route;

  /// Child route configurations that can be nested under this route.
  final List<EndDrawerRouteStackConfig> subRoutes;

  const EndDrawerRouteStackConfig({
    required this.route,
    this.subRoutes = const [],
  });

  /// Builds a list of routes that need to be pushed based on the current path.
  ///
  /// For a path like `/myactions/proposal_approval`, this returns:
  /// ['/myactions', '/myactions/proposal_approval']
  @override
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
/// This creates a transparent page with a [Scaffold] that automatically opens
/// its end drawer, keeping the previous page visible underneath.
///
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
      arguments: {
        ...state.pathParameters,
        ...state.uri.queryParameters,
      },
      restorationId: state.pageKey.value,
      opaque: false,
      barrierDismissible: true,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (_, _, _, child) => child,
      child: DrawerPageScaffold(
        drawerChild: builder(context, state, navigator),
        routeStackResolver: routeStackConfig,
        isShell: true,
      ),
    );
  }
}

extension RouteSettingsShellExt on RouteSettings {
  bool get isDrawerShell => name == EndDrawerShellPageTransitionMixin.transitionPageName;
}
