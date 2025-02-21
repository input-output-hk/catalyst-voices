import 'package:catalyst_voices/pages/proposal/proposal.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'proposal_route.g.dart';

const milestone = Routes.currentMilestone;

@TypedGoRoute<ProposalRoute>(path: '/$milestone/proposal/:proposalId')
final class ProposalRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String proposalId;
  final String? version;
  final bool draft;

  const ProposalRoute({
    required this.proposalId,
    this.version,
    this.draft = false,
  });

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProposalPage(
      id: proposalId,
      version: version,
      isDraft: draft,
    );
  }
}
