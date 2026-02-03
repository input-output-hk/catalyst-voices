import 'package:catalyst_voices/pages/voting_list/voting_list_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/transitions/end_drawer_page_transition_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'voting_list_route.g.dart';

@TypedGoRoute<VotingListRoute>(
  path: '/voting_list',
  name: 'voting_list',
)
final class VotingListRoute extends GoRouteData
    with $VotingListRoute, CompositeRouteGuardMixin, EndDrawerPageTransitionMixin {
  const VotingListRoute();

  @override
  List<RouteGuard> get routeGuards => [
    const SessionUnlockedGuard(),
    const UserAccessGuard(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VotingListPage();
  }
}
