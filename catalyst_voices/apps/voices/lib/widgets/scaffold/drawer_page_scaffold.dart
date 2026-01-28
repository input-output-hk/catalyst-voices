import 'dart:async';

import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/transitions.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerPageScaffold extends StatefulWidget {
  final Widget drawerChild;
  final bool isShell;
  final DrawerPageScaffoldRouteStackResolver routeStackResolver;

  const DrawerPageScaffold({
    super.key,
    required this.drawerChild,
    this.isShell = false,
    this.routeStackResolver = const _DefaultResolver(),
  });

  @override
  State<DrawerPageScaffold> createState() => _DrawerPageScaffoldState();
}

//ignore: one_member_abstracts
abstract interface class DrawerPageScaffoldRouteStackResolver {
  List<String> buildRouteStack(String currentPath);
}

final class _DefaultResolver implements DrawerPageScaffoldRouteStackResolver {
  const _DefaultResolver();

  @override
  List<String> buildRouteStack(String currentPath) => const <String>[];
}

class _DrawerPageScaffoldState extends State<DrawerPageScaffold> {
  /// The duration comes from Flutter's DrawerController which uses
  /// `_kBaseSettleDuration = Duration(milliseconds: 246)`.
  ///
  /// See: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/drawer.dart
  final _drawerAnimationDuration = const Duration(milliseconds: 246);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasPopped = false;
  bool _wasOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      endDrawerEnableOpenDragGesture: false,
      drawerEnableOpenDragGesture: false,
      onEndDrawerChanged: _onEndDrawerChanged,
      endDrawer: VoicesDrawer(
        width: 500,
        child: widget.drawerChild,
      ),
      body: const SizedBox.shrink(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupNavigation();
      _scaffoldKey.currentState?.openEndDrawer();
    });
  }

  List<String> _buildRouteStackWithQuery(String currentPath, String queryString) {
    final routes = widget.routeStackResolver.buildRouteStack(currentPath);
    if (routes.isEmpty || queryString.isEmpty) return routes;

    return routes.map((route) => '$route?$queryString').toList();
  }

  void _handleExistingRouteStack({
    required GoRouter router,
    required String currentPath,
    required String queryString,
    required RouteMatchList currentConfiguration,
  }) {
    final requiredRoutes = _buildRouteStackWithQuery(currentPath, queryString);
    final existingPaths = requiredRoutes.isNotEmpty
        ? currentConfiguration.matches.map((match) => match.matchedLocation).toSet()
        : const <String>{};

    final hasMissingRoutes = requiredRoutes.any(
      (route) => !existingPaths.contains(Uri.parse(route).path),
    );

    if (hasMissingRoutes) {
      _pushRoutesSequentially(router, requiredRoutes);
    }
  }

  void _handleFreshNavigation({
    required GoRouter router,
    required String currentPath,
    required String queryString,
  }) {
    router.go(Routes.initialLocation);
    final routesToPush = _buildRouteStackWithQuery(currentPath, queryString);
    _pushRoutesSequentially(router, routesToPush);
  }

  bool _hasExistingRoutes(RouteMatchList configuration) {
    return configuration.matches.length > 1;
  }

  Future<void> _onEndDrawerChanged(bool isOpened) async {
    if (isOpened) {
      _wasOpened = true;
      return;
    }

    if (_wasOpened && !_hasPopped) {
      _hasPopped = true;
      await _popAfterDrawerClose();
    }
  }

  Future<void> _popAfterDrawerClose() async {
    await Future<void>.delayed(_drawerAnimationDuration);

    if (!mounted) return;

    if (widget.isShell) {
      _popShell();
    } else {
      unawaited(Navigator.of(context).maybePop());
    }
  }

  void _popShell() {
    var foundShellRoute = false;

    Navigator.of(context).popUntil((route) {
      if (route.settings.isDrawerShell) {
        foundShellRoute = true;
        return false;
      }

      return foundShellRoute;
    });
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

  void _setupNavigation() {
    final router = GoRouter.of(context);
    final currentConfiguration = router.routerDelegate.currentConfiguration;
    final currentPath = currentConfiguration.last.matchedLocation;
    final queryString = router.routeInformationProvider.value.uri.query;

    if (_hasExistingRoutes(currentConfiguration)) {
      _handleExistingRouteStack(
        router: router,
        currentPath: currentPath,
        queryString: queryString,
        currentConfiguration: currentConfiguration,
      );
    } else {
      _handleFreshNavigation(
        router: router,
        currentPath: currentPath,
        queryString: queryString,
      );
    }
  }
}
