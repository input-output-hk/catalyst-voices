import 'package:catalyst_voices/pages/proposal/proposal.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/proposal_submission_guard.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'proposal_route.g.dart';

@TypedGoRoute<ProposalRoute>(path: '/proposal/:proposalId')
final class ProposalRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  final String proposalId;
  final String? version;
  final bool local;

  const ProposalRoute({
    required this.proposalId,
    this.version,
    this.local = false,
  });

  ProposalRoute.fromRef({required DocumentRef ref})
      : this(
          proposalId: ref.id,
          version: ref.version,
          local: ref is DraftRef,
        );

  @override
  List<RouteGuard> get routeGuards => const [ProposalSubmissionGuard()];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final ref = DocumentRef.build(
      id: proposalId,
      version: version,
      isDraft: local,
    );
    return ProposalPage(ref: ref);
  }

  static bool isPath(String path) {
    return ($proposalRoute as GoRoute).path == path;
  }
}
