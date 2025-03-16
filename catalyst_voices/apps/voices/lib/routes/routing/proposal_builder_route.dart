import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'proposal_builder_route.g.dart';

@TypedGoRoute<ProposalBuilderDraftRoute>(
  path: '/${Routes.currentMilestone}/workspace/proposal_builder/draft',
)
final class ProposalBuilderDraftRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String? categoryId;

  const ProposalBuilderDraftRoute({
    this.categoryId,
  });

  factory ProposalBuilderDraftRoute.fromRef({
    required SignedDocumentRef categoryId,
  }) {
    return ProposalBuilderDraftRoute(categoryId: categoryId.id);
  }

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final categoryId = this.categoryId;
    final categoryRef =
        categoryId != null ? SignedDocumentRef(id: categoryId) : null;
    return ProposalBuilderPage(categoryId: categoryRef);
  }
}

@TypedGoRoute<ProposalBuilderRoute>(
  path: '/${Routes.currentMilestone}/workspace/proposal_builder/:proposalId',
)
final class ProposalBuilderRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String proposalId;
  final bool local;

  const ProposalBuilderRoute({
    required this.proposalId,
    this.local = false,
  });

  factory ProposalBuilderRoute.fromRef({
    required DocumentRef ref,
  }) {
    return ProposalBuilderRoute(
      proposalId: ref.id,
      local: ref is DraftRef,
    );
  }

  @override
  List<RouteGuard> get routeGuards => const [
        SessionUnlockedGuard(),
        UserAccessGuard(),
      ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final ref = DocumentRef.build(
      id: proposalId,
      isDraft: local,
    );

    return ProposalBuilderPage(proposalId: ref);
  }
}
