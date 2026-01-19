import 'package:catalyst_voices/pages/proposal_builder/proposal_builder_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/guards/session_unlocked_guard.dart';
import 'package:catalyst_voices/routes/guards/user_access_guard.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'proposal_builder_route.g.dart';

@TypedGoRoute<ProposalBuilderDraftRoute>(
  path: '/workspace/proposal_builder/draft',
  name: 'proposal_builder_draft',
)
final class ProposalBuilderDraftRoute extends GoRouteData
    with $ProposalBuilderDraftRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
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
  List<RouteGuard> get routeGuards => [
    const SessionUnlockedGuard(),
    const UserAccessGuard(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final categoryId = this.categoryId;
    final categoryRef = categoryId != null ? SignedDocumentRef(id: categoryId) : null;
    return ProposalBuilderPage(categoryId: categoryRef);
  }
}

@TypedGoRoute<ProposalBuilderRoute>(
  path: '/workspace/proposal_builder/:proposalId',
  name: 'proposal_builder_edit',
)
final class ProposalBuilderRoute extends GoRouteData
    with $ProposalBuilderRoute, FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String proposalId;
  final String? proposalVersion;
  final bool local;

  const ProposalBuilderRoute({
    required this.proposalId,
    this.proposalVersion,
    this.local = false,
  });

  factory ProposalBuilderRoute.fromRef({
    required DocumentRef ref,
  }) {
    return ProposalBuilderRoute(
      proposalId: ref.id,
      proposalVersion: ref.ver,
      local: ref is DraftRef,
    );
  }

  @override
  List<RouteGuard> get routeGuards => [
    const SessionUnlockedGuard(),
    const UserAccessGuard(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final ref = DocumentRef.build(
      id: proposalId,
      ver: proposalVersion,
      isDraft: local,
    );

    return ProposalBuilderPage(proposalId: ref);
  }
}
