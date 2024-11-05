import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A divider with text placed in the middle.
///
/// This widget is a variation of [Divider] that displays a text child centered
/// between two divider lines. It provides customization options for indent,
/// gap, and overall size.
///
/// Example usage:
///
/// ```dart
/// VoicesTextDivider(
///   child: Text('My Name'),
/// ),
/// ```
class VoicesTextDivider extends StatelessWidget {
  /// The indentation of the divider lines from the start and end of the row.
  final double indent;

  /// The gap between the divider lines and the text child.
  final double nameGap;

  /// The size of the row containing the divider lines and text child.
  final MainAxisSize mainAxisSize;

  /// The text to display in the middle of the divider.
  final Widget child;

  const VoicesTextDivider({
    super.key,
    this.indent = 24,
    this.nameGap = 8,
    this.mainAxisSize = MainAxisSize.min,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DividerTheme(
      data: const DividerThemeData(space: 40),
      child: Row(
        mainAxisSize: mainAxisSize,
        children: [
          Expanded(child: Divider(indent: indent)),
          SizedBox(width: nameGap),
          DefaultTextStyle(
            style: (theme.textTheme.bodyLarge ?? const TextStyle())
                .copyWith(color: theme.colors.textOnPrimary),
            child: child,
          ),
          SizedBox(width: nameGap),
          Expanded(child: Divider(endIndent: indent)),
        ],
      ),
    );
  }
}
