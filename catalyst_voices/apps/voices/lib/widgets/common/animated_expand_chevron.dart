import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class AnimatedExpandChevron extends StatelessWidget {
  final bool isExpanded;
  final double? size;

  const AnimatedExpandChevron({
    super.key,
    required this.isExpanded,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      key: const Key('AnimatedExpandChevron'),
      turns: isExpanded ? 0.25 : 0,
      duration: const Duration(milliseconds: 250),
      child: VoicesAssets.icons.chevronRight.buildIcon(size: size),
    );
  }
}
