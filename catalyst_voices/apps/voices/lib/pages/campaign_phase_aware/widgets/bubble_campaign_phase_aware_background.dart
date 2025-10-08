import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class BubbleCampaignPhaseAwareBackground extends StatelessWidget {
  const BubbleCampaignPhaseAwareBackground({super.key});

  @override
  Widget build(BuildContext context) {
    if (CatalystFormFactor.current.isMobile) {
      return const _MobileBubbleCampaignPhaseAwareBackground();
    }
    return CatalystImage.asset(
      VoicesAssets.images.bgBubbles.path,
      fit: BoxFit.fill,
    );
  }
}

class _MobileBubbleCampaignPhaseAwareBackground extends StatelessWidget {
  const _MobileBubbleCampaignPhaseAwareBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: CatalystImage.asset(
            VoicesAssets.images.mobileLeftLayer.path,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: CatalystImage.asset(
            VoicesAssets.images.mobileRightLayer.path,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
}
