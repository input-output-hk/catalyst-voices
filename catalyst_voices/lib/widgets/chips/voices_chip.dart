import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesChip extends StatelessWidget {
  final Widget content;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final BorderRadius borderRadius;

  const VoicesChip({
    super.key,
    required this.content,
    this.leading,
    this.trailing,
    this.backgroundColor,
    required this.borderRadius,
  });

  const VoicesChip.round({
    super.key,
    required this.content,
    this.leading,
    this.trailing,
    this.backgroundColor,
  }) : borderRadius = const BorderRadius.all(Radius.circular(32));

  const VoicesChip.rectangular({
    super.key,
    required this.content,
    this.leading,
    this.trailing,
    this.backgroundColor,
  }) : borderRadius = const BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: backgroundColor != null
            ? null
            : Border.all(
                color: Theme.of(context).colors.outlineBorderVariant!,
              ),
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) leading!,
          content,
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
