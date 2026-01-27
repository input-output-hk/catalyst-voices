import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin EndDrawerPageTransitionMixin on GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
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
        drawerChild: build(context, state),
      ),
    );
  }
}
