import 'package:catalyst_voices/pages/actions/actions_page.dart';
import 'package:catalyst_voices/pages/co_proposers_consent/co_proposers_consent_page.dart';
import 'package:catalyst_voices/pages/proposal_approval/proposal_approval_page.dart';
import 'package:catalyst_voices/routes/routing/transitions/slide_from_end_drawer_page_transition_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'actions_route.g.dart';

@TypedGoRoute<ActionsRoute>(
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
)
final class ActionsRoute extends GoRouteData with SlideFromEndDrawerPageTransitionMixin {
  const ActionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ActionsPage();
  }
}

final class CoProposersConsentRoute extends GoRouteData with SlideFromEndDrawerPageTransitionMixin {
  const CoProposersConsentRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CoProposersConsentPage();
  }
}

final class ProposalApprovalRoute extends GoRouteData with SlideFromEndDrawerPageTransitionMixin {
  const ProposalApprovalRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProposalApprovalPage();
  }
}
