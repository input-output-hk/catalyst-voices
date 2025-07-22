import 'package:catalyst_voices/pages/campaign/stage/after_proposal_submission_page.dart';
import 'package:catalyst_voices/pages/campaign/stage/pre_proposal_submission_page.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/campaign_phase_aware.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalSubmissionPhaseAware extends StatelessWidget {
  final Widget activeChild;

  const ProposalSubmissionPhaseAware({super.key, required this.activeChild});

  @override
  Widget build(BuildContext context) {
    return CampaignPhaseAware.when(
      phase: CampaignPhaseType.proposalSubmission,
      upcoming: (_, phase) => PreProposalSubmissionPage(startDate: phase.timeline.from),
      active: (_, __) => activeChild,
      post: (_, __) => const AfterProposalSubmissionPage(),
    );
  }
}
