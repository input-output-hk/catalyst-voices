import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/campaign_stage_route.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Restricts access to screen base on current Campaign state.
final class ProposalSubmissionGuard implements RouteGuard {
  const ProposalSubmissionGuard();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final path = state.path;
    final campaignState = context.read<CampaignStageCubit>().state;

    return switch (campaignState) {
      AfterProposalSubmissionStage() when path != null && ProposalRoute.isPath(path) => null,
      AfterProposalSubmissionStage() => const CampaignStageRoute().location,
      PreProposalSubmissionStage() when path != null && ProposalRoute.isPath(path) =>
        const CampaignStageRoute().location,
      ProposalSubmissionStage() when state.matchedLocation == const CampaignStageRoute().location =>
        const DiscoveryRoute().location,
      _ => null,
    };
  }
}
