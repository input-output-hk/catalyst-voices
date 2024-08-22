import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Note. Colors were not defined well in figma so we may need to change
/// them later.
class VoicesPlainTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const VoicesPlainTooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      richMessage: WidgetSpan(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.iconsBackground,
            ),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colors.iconsForeground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}
