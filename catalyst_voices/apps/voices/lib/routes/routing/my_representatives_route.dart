import 'package:catalyst_voices/pages/representatives/my/my_representatives_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/transitions/transitions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'my_representatives_route.g.dart';

@TypedGoRoute<MyRepresentativesRoute>(
  path: '/my_representatives',
  name: 'my_representatives',
)
final class MyRepresentativesRoute extends GoRouteData
    with $MyRepresentativesRoute, CompositeRouteGuardMixin, EndDrawerPageTransitionMixin {
  const MyRepresentativesRoute();

  @override
  List<RouteGuard> get routeGuards => [
    const SessionUnlockedGuard(),
    const UserAccessGuard(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyRepresentativesPage();
  }
}
