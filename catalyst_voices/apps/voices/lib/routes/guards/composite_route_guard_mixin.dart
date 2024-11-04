import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A default implementation for [redirect]
/// that can handle multiple [routeGuards].
mixin CompositeRouteGuardMixin on GoRouteData {
  /// An abstract getter to be overriden by all [RouteGuard]'s
  /// that a given route will have.
  ///
  /// The guards are called in the order they are returned
  /// from this method in a FIFO manner.
  List<RouteGuard> get routeGuards;

  /// A default implementation of route guard logic, it's allowed to override
  /// it to add custom redirect logic however make sure to call
  /// `super.redirect()` if your own implementation doesn't redirect anywhere.
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    for (final guard in routeGuards) {
      final location = await guard.redirect(context, state);
      if (location != null) {
        return location;
      }
    }

    return null;
  }
}
