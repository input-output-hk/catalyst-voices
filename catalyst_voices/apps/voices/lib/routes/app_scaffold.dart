import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

final class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(
          key: key ?? const ValueKey<String>('AppScaffoldWithNavBar'),
        );

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      useDrawer: false,
      selectedIndex: navigationShell.currentIndex,
      body: (context) => navigationShell,
      onSelectedIndexChange: (idx) => _onTap(idx, context),
      destinations: const [],
    );
  }

  void _onTap(
    int index,
    BuildContext context,
  ) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
