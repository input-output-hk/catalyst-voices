import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Voices variation of [Divider] that requires name in middle of divider.
class VoicesNamedDivider extends StatelessWidget {
  final Widget name;
  final double indent;
  final double nameGap;

  const VoicesNamedDivider({
    super.key,
    required this.name,
    this.indent = 24,
    this.nameGap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DividerTheme(
      data: const DividerThemeData(space: 40),
      child: Row(
        children: [
          Expanded(child: Divider(indent: indent)),
          SizedBox(width: nameGap),
          DefaultTextStyle(
            style: (theme.textTheme.bodyLarge ?? const TextStyle())
                .copyWith(color: theme.colors.textOnPrimary),
            child: name,
          ),
          SizedBox(width: nameGap),
          Expanded(child: Divider(endIndent: indent)),
        ],
      ),
    );
  }
}
