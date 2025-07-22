import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class LoadingCampaignPhaseAware extends StatelessWidget {
  const LoadingCampaignPhaseAware({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: _Background(),
        ),
        Align(
          child: VoicesAssets.lottie.voicesLoader.buildLottie(
            width: 220,
            height: 220,
            repeat: true,
          ),
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return CatalystImage.asset(
      VoicesAssets.images.bgBubbles.path,
      fit: BoxFit.fill,
    );
  }
}
