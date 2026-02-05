import 'package:catalyst_voices/pages/proposal_viewer/proposal_viewer_page.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'proposal_route.g.dart';

@TypedGoRoute<ProposalRoute>(
  path: '/proposal/:proposalId',
  name: 'proposal_viewer',
)
final class ProposalRoute extends GoRouteData with $ProposalRoute, FadePageTransitionMixin {
  final String proposalId;
  final String? version;
  final bool local;

  const ProposalRoute({
    required this.proposalId,
    this.version,
    this.local = false,
  });

  factory ProposalRoute.fromPath(Uri value) {
    final proposalSegmentIndex = value.pathSegments.indexOf('proposal');
    if (proposalSegmentIndex == -1) {
      throw ArgumentError('$value is not a proposal route path', 'value');
    }

    return ProposalRoute(
      proposalId: value.pathSegments[proposalSegmentIndex + 1],
      version: value.queryParameters['version'],
      local:
          _$convertMapValue(
            'local',
            value.queryParameters,
            _$boolConverter,
          ) ??
          false,
    );
  }

  ProposalRoute.fromRef({required DocumentRef ref})
    : this(
        proposalId: ref.id,
        version: ref.ver,
        local: ref is DraftRef,
      );

  DocumentRef get ref => DocumentRef.build(
    id: proposalId,
    ver: version,
    isDraft: local,
  );

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProposalViewerPage(ref: ref);
  }

  static bool isPath(Uri uri) {
    return uri.path.contains('/proposal/');
  }
}
