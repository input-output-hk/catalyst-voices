import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'proposal_builder_route.g.dart';

@TypedGoRoute<ProposalBuilderDraftRoute>(
  path: '/${Routes.currentMilestone}/workspace/proposal_builder/draft',
)
final class ProposalBuilderDraftRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String? templateId;

  const ProposalBuilderDraftRoute({
    this.templateId,
  });

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProposalBuilderPage(templateId: templateId);
  }
}

@TypedGoRoute<ProposalBuilderRoute>(
  path: '/${Routes.currentMilestone}/workspace/proposal_builder/:proposalId',
)
final class ProposalBuilderRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String proposalId;

  const ProposalBuilderRoute({
    required this.proposalId,
  });

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProposalBuilderPage(proposalId: proposalId);
  }
}
