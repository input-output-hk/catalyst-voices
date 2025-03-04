import 'package:catalyst_voices/pages/proposal/proposal.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'proposal_route.g.dart';

const milestone = Routes.currentMilestone;

@TypedGoRoute<ProposalRoute>(path: '/$milestone/proposal/:proposalId')
final class ProposalRoute extends GoRouteData with FadePageTransitionMixin {
  final String proposalId;
  final String? version;
  final bool local;

  const ProposalRoute({
    required this.proposalId,
    this.version,
    this.local = false,
  });

  ProposalRoute.from({required DocumentRef ref})
      : this(
          proposalId: ref.id,
          version: ref.version,
          local: ref is DraftRef,
        );

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final ref = DocumentRef.build(
      id: proposalId,
      version: version,
      isDraft: local,
    );

    return ProposalPage(ref: ref);
  }
}
