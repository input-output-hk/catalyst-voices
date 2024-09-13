import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class PageFooter extends StatelessWidget {
  final Widget child;

  const PageFooter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv2,
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: child,
    );
  }
}
