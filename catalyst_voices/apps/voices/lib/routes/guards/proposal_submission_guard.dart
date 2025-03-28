import 'dart:async';

import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/campaign_stage_route.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final class ProposalSubmissionGuard implements RouteGuard {
  const ProposalSubmissionGuard();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final campaignState = context.read<CampaignStageCubit>().state;
    if (campaignState is ProposalSubmissionStage) {
      return null;
    } else {
      return const CampaignStageRoute().location;
    }
  }
}
