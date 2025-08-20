import 'package:catalyst_voices/pages/campaign_phase_aware/widgets/bubble_campaign_phase_aware_background.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class LoadingCampaignPhaseAware extends StatelessWidget {
  const LoadingCampaignPhaseAware({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: BubbleCampaignPhaseAwareBackground(),
        ),
        Align(
          child: VoicesAssets.lottie.voicesLoader.buildLottie(
            width: 300,
            height: 300,
            repeat: true,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
