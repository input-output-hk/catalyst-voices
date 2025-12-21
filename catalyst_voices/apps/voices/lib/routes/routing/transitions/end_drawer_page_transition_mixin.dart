import 'dart:async';

import 'package:catalyst_voices/routes/routing/actions_route.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A mixin that provides a drawer-like page transition for [ShellRouteData].
///
/// This creates a transparent page with a Scaffold that automatically opens
/// its endDrawer, keeping the previous page visible underneath.

/// Use this when you want the shell route to display its content in
/// an end drawer, allowing nested routes to change the drawer content.
mixin EndDrawerShellPageTransitionMixin on ShellRouteData {
  static const transitionPageName = 'EndDrawerShellPageTransition';

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
      child: _EndDrawerScaffold(drawerContent: builder(context, state, navigator)),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    );
  }
}

class _EndDrawerScaffold extends StatefulWidget {
  final Widget drawerContent;

  const _EndDrawerScaffold({
    required this.drawerContent,
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
      if (currentConfiguration.matches.length >= 2) {
        _scaffoldKey.currentState?.openEndDrawer();
      } else {
        router.go(Routes.initialLocation);
        final currentPath = currentConfiguration.fullPath;

        if (currentPath.contains(const ActionsRoute().location)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            unawaited(router.push(const ActionsRoute().location));
            if (currentPath.contains(const ProposalApprovalRoute().location)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                unawaited(router.push(const ProposalApprovalRoute().location));
              });
            } else if (currentPath.contains(const CoProposersConsentRoute().location)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                unawaited(router.push(const CoProposersConsentRoute().location));
              });
            }
          });
        }
      }
    });
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
