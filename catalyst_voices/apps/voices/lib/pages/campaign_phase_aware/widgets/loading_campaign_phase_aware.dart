import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/bubble_campaign_phase_aware_background.dart';
import 'package:catalyst_voices/widgets/indicators/voices_loading_indicator.dart';
import 'package:flutter/material.dart';

class LoadingCampaignPhaseAware extends StatelessWidget {
  const LoadingCampaignPhaseAware({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: BubbleCampaignPhaseAwareBackground(),
        ),
        Align(
          child: VoicesLoadingIndicator(),
        ),
      ],
    );
  }
}
