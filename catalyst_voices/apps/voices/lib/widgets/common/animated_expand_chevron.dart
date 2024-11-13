import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class AnimatedExpandChevron extends StatelessWidget {
  final bool isExpanded;

  const AnimatedExpandChevron({
    super.key,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0 : 0.25,
      duration: const Duration(milliseconds: 250),
      child: VoicesAssets.icons.chevronRight.buildIcon(),
    );
  }
}
