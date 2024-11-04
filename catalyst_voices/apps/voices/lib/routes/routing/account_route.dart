import 'dart:async';

import 'package:catalyst_voices/pages/account/account_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'account_route.g.dart';

@TypedGoRoute<AccountRoute>(
  path: '/${Routes.currentMilestone}/account',
)
final class AccountRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const AccountRoute();

  @override
  List<RouteGuard> get routeGuards => [const SessionUnlockedGuard()];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountPage();
  }
}
