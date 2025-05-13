import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/campaign_stage_route.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final class ProposalSubmissionGuard implements RouteGuard {
  const ProposalSubmissionGuard();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final campaignState = context.read<CampaignStageCubit>().state;
    if (campaignState is ProposalSubmissionStage) {
      if (state.path == const CampaignStageRoute().location) {
        return const DiscoveryRoute().location;
      }
      return null;
    } else {
      return const CampaignStageRoute().location;
    }
  }
}

final class ReadOnlyProposalViewGuard implements RouteGuard {
  const ReadOnlyProposalViewGuard();
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final campaignState = context.read<CampaignStageCubit>().state;

    if (state.matchedLocation.startsWith('/proposal/')) {
      if (campaignState is AfterProposalSubmissionStage) {
        final proposalId = state.pathParameters['proposalId'];
        return ProposalRoute(
          proposalId: proposalId!,
          version: state.uri.queryParameters['version'],
          local: state.uri.queryParameters['local'] == 'true',
          readOnly: true,
        ).location;
      } else if (campaignState is PreProposalSubmissionStage) {
        return const CampaignStageRoute().location;
      }
    }

    return null;
  }
}
