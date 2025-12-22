import 'package:catalyst_voices/pages/actions/actions_page.dart';
import 'package:catalyst_voices/pages/actions/actions_page_tab.dart';
import 'package:catalyst_voices/pages/actions/actions_shell_page.dart';
import 'package:catalyst_voices/pages/co_proposers_consent/co_proposers_consent_page.dart';
import 'package:catalyst_voices/pages/proposal_approval/proposal_approval_page.dart';
import 'package:catalyst_voices/routes/routing/transitions/end_drawer_page_transition_mixin.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'actions_route.g.dart';

final class ActionsRoute extends GoRouteData {
  final String? tab;

  const ActionsRoute({
    this.tab,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final tab = ActionsPageTab.values.asNameMap()[this.tab] ?? ActionsPageTab.all;
    return ActionsPage(tab: tab);
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
      EndDrawerRouteStackConfig(
        route: const ProposalApprovalRoute().location,
      ),
      EndDrawerRouteStackConfig(
        route: const CoProposersConsentRoute().location,
      ),
    ],
  );

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return ActionsShellPage(
      child: navigator,
    );
  }
}

final class CoProposersConsentRoute extends GoRouteData with FadePageTransitionMixin {
  const CoProposersConsentRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CoProposersConsentPage();
  }
}

final class ProposalApprovalRoute extends GoRouteData with FadePageTransitionMixin {
  const ProposalApprovalRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProposalApprovalPage();
  }
}
