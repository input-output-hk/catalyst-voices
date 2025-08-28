import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class VoicesLoadingIndicator extends StatelessWidget {
  final double width;
  final double height;
  final bool repeat;
  final BoxFit fit;

  const VoicesLoadingIndicator({
    super.key,
    this.width = 300,
    this.height = 300,
    this.repeat = true,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAssets.lottie.voicesLoader.buildLottie(
      width: width,
      height: height,
      repeat: repeat,
      fit: fit,
    );
  }
}
