import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class BubbleCampaignPhaseAwareBackground extends StatelessWidget {
  const BubbleCampaignPhaseAwareBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalystImage.asset(
      VoicesAssets.images.bgBubbles.path,
      fit: BoxFit.fill,
    );
  }
}
