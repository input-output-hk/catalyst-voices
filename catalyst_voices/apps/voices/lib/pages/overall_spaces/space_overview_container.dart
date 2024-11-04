import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SpaceOverviewContainer extends StatelessWidget {
  final Widget child;

  const SpaceOverviewContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(width: 360),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
