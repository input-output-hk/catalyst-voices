import 'package:flutter/material.dart';

/// A vertical divider that ensures consistent color based on [DividerTheme].
///
/// This widget wraps [VerticalDivider] and explicitly sets its `color`
/// property to match the current [DividerTheme]. This is necessary because M3
/// overrides the default color behavior.
///
/// You can customize the divider's appearance using the [indent] and
/// [endIndent] properties.
class VoicesVerticalDivider extends StatelessWidget {
  /// The indentation of the divider from the start of the column.
  ///
  /// See [VerticalDivider.indent] for more details.
  final double? indent;

  /// The indentation of the divider from the end of the column.
  ///
  /// See [VerticalDivider.endIndent] for more details.
  final double? endIndent;

  /// Optional color of divider.
  final Color? color;

  const VoicesVerticalDivider({
    super.key,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      indent: indent,
      endIndent: endIndent,
      // M3 will override it and use outline color that's why setting
      // it explicitly.
      color: color ?? DividerTheme.of(context).color,
    );
  }
}
