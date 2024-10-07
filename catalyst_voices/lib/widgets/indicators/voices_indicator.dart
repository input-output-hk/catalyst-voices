import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

enum VoicesIndicatorType {
  normal,
  error,
  success;

  Color _iconColor(BuildContext context) {
    return switch (this) {
      VoicesIndicatorType.normal => Theme.of(context).colors.iconsForeground!,
      VoicesIndicatorType.error => Theme.of(context).colors.iconsError!,
      VoicesIndicatorType.success => Theme.of(context).colors.iconsSuccess!,
    };
  }
}

class VoicesIndicator extends StatelessWidget {
  final VoicesIndicatorType type;
  final SvgGenImage icon;
  final Widget message;
  final Widget? action;

  const VoicesIndicator({
    super.key,
    this.type = VoicesIndicatorType.normal,
    required this.icon,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colors.outlineBorderVariant!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon.buildIcon(
            color: type._iconColor(context),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DefaultTextStyle.merge(
              style: (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
                height: 1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              child: message,
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 10),
            action!,
          ],
        ],
      ),
    );
  }
}
