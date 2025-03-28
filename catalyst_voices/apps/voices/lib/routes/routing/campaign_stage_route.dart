import 'package:catalyst_voices/pages/campaign/stage/after_proposal_submission_page.dart';
import 'package:catalyst_voices/pages/campaign/stage/pre_proposal_submission_page.dart';
import 'package:catalyst_voices/routes/guards/composite_route_guard_mixin.dart';
import 'package:catalyst_voices/routes/guards/proposal_submission_guard.dart';
import 'package:catalyst_voices/routes/guards/route_guard.dart';
import 'package:catalyst_voices/routes/routing/routes.dart';
import 'package:catalyst_voices/routes/routing/transitions/fade_page_transition_mixin.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'campaign_stage_route.g.dart';

@TypedGoRoute<CampaignStageRoute>(
  path: '/${Routes.currentMilestone}/campaign_stage',
)
final class CampaignStageRoute extends GoRouteData
    with FadePageTransitionMixin, CompositeRouteGuardMixin {
  const CampaignStageRoute();

  @override
  List<RouteGuard> get routeGuards => [const ProposalSubmissionGuard()];

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final campaignState = context.read<CampaignStageCubit>().state;

    if (campaignState is PreProposalSubmissionStage) {
      return PreProposalSubmissionPage(
        startDate: campaignState.startDate,
      );
    } else {
      return const AfterProposalSubmissionPage();
    }
  }
}
