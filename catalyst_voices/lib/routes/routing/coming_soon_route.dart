import 'package:catalyst_voices/pages/coming_soon/coming_soon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'coming_soon_route.g.dart';

@TypedGoRoute<ComingSoonRoute>(path: '/')
final class ComingSoonRoute extends GoRouteData {
  const ComingSoonRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ComingSoonPage();
  }
}
