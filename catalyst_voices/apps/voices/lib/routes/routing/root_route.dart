import 'dart:async';

import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'root_route.g.dart';

@TypedGoRoute<RootRoute>(path: '/')
final class RootRoute extends GoRouteData {
  const RootRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) =>
      const DiscoveryRoute().location;
}
