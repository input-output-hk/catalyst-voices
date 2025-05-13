import 'package:catalyst_voices/widgets/video/video_player.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final AlignmentGeometry alignment;
  final VideoCacheKey asset;
  final BoxConstraints constraints;

  final Widget child;

  const HeroSection({
    super.key,
    this.alignment = Alignment.bottomLeft,
    required this.asset,
    this.constraints = const BoxConstraints.tightFor(height: 650),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: alignment,
      children: [
        _Background(
          asset: asset,
          constraints: constraints,
        ),
        Align(
          alignment: alignment,
          child: child,
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  final VideoCacheKey asset;
  final BoxConstraints constraints;

  const _Background({
    required this.asset,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: VoicesVideoPlayer(
        key: const Key('HeroBackgroundVideo'),
        asset: asset,
      ),
    );
  }
}
