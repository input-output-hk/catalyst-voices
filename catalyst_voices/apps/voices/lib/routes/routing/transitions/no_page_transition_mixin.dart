import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin NoPageTransitionMixin on GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      name: state.name ?? state.path,
      arguments: <String, String>{
        ...state.pathParameters,
        ...state.uri.queryParameters,
      },
      restorationId: state.pageKey.value,
      child: build(context, state),
    );
  }
}
