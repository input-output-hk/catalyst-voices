import 'package:catalyst_voices/widgets/countdown/campaign_phase_countdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class PreVotingContent extends StatelessWidget {
  final CampaignPhase phase;
  final int fundNumber;

  const PreVotingContent({
    super.key,
    required this.phase,
    required this.fundNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CampaignPhaseCountdown(
          phaseCountdown: CampaignPhaseCountdownViewModel(
            date: phase.timeline.from!,
            type: phase.type,
            fundNumber: fundNumber,
          ),
        ),
      ],
    );
  }
}
