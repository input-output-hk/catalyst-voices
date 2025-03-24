import 'dart:ui';

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A full screen overlay that blurs the background
/// and shows a loading animation at the center.
class VoicesLoadingOverlay extends StatelessWidget {
  final bool show;

  const VoicesLoadingOverlay({
    super.key,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !show,
      child: TickerMode(
        enabled: show,
        child: AbsorbPointer(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colors.onSurfaceNeutral016.withAlpha(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: VoicesAssets.lottie.voicesLoader.buildLottie(
                    width: 92,
                    height: 92,
                    repeat: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
