import 'package:catalyst_voices/pages/actions/actions/actions_page.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/actions/co_proposers_consent/co_proposers_consent_page.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/proposal_approval_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/transitions/end_drawer_shell_page_transition_mixin.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'actions_route.g.dart';

final class ActionsRoute extends GoRouteData with $ActionsRoute, CompositeRouteGuardMixin {
  final String? tab;

  const ActionsRoute({this.tab});

  @override
  List<RouteGuard> get routeGuards => [
    const SessionUnlockedGuard(),
    const UserAccessGuard(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final resolvedTab = ActionsPageTab.values.asNameMap()[tab] ?? ActionsPageTab.all;
    return ActionsPage(tab: resolvedTab);
  }
}

@TypedShellRoute<ActionsShellRoute>(
  routes: [
    TypedGoRoute<ActionsRoute>(
      path: '/myactions',
      name: 'myactions',
      routes: [
        TypedGoRoute<ProposalApprovalRoute>(
          path: 'proposal_approval',
          name: 'proposal_approval',
        ),
        TypedGoRoute<CoProposersConsentRoute>(
          path: 'co_proposers_consent',
          name: 'co_proposers_consent',
        ),
      ],
    ),
  ],
)
final class ActionsShellRoute extends ShellRouteData with EndDrawerShellPageTransitionMixin {
  const ActionsShellRoute();

  @override
  EndDrawerRouteStackConfig get routeStackConfig => EndDrawerRouteStackConfig(
    route: const ActionsRoute().location,
    subRoutes: [
      EndDrawerRouteStackConfig(route: const ProposalApprovalRoute().location),
      EndDrawerRouteStackConfig(route: const CoProposersConsentRoute().location),
    ],
  );

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return ActionsShellPage(child: navigator);
  }
}

final class CoProposersConsentRoute extends GoRouteData
    with $CoProposersConsentRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
  const CoProposersConsentRoute();

  @override
  List<RouteGuard> get routeGuards => [
    const SessionUnlockedGuard(),
    const UserAccessGuard(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CoProposersConsentPage();
  }
}

final class ProposalApprovalRoute extends GoRouteData
    with $ProposalApprovalRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
  const ProposalApprovalRoute();

  @override
  List<RouteGuard> get routeGuards => [
    const SessionUnlockedGuard(),
    const UserAccessGuard(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProposalApprovalPage();
  }
}
