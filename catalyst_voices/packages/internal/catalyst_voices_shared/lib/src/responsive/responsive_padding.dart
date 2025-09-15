import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/widgets.dart';

/// A [ResponsivePadding] is a StatelessWidget that applies a padding based on
/// the current screen size.
///
/// The widget wraps its [child] in a [ResponsiveBuilder] that calculates the
/// proper padding value based on the screen size and wraps it again in a Padding
/// to display the selected padding value.
///
/// The possible arguments are `xs`, `sm`, `md`, `lg` following the
/// Material design standards and the ResponsiveBuilder arguments.
/// Each screen size has a default value to simplify widget usage.
///
/// Example usage:
///
/// ```dart
/// ResponsivePadding(
///   xs: const EdgeInsets.all(4.0),
///   sm: const EdgeInsets.all(6.0),
///   md: const EdgeInsets.only(top: 6.0),
///   lg: const EdgeInsets.symmetric(vertical: 15.0),
///   child: Text('This is an example text with dynamic padding.')
/// );
/// ```
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final Map<ResponsiveBreakpointKey, EdgeInsets> _paddings;

  ResponsivePadding({
    super.key,
    required this.child,
    EdgeInsets? xs,
    EdgeInsets? sm,
    EdgeInsets? md,
    EdgeInsets? lg,
  }) : _paddings = {
         if (xs != null) ResponsiveBreakpointKey.xs: xs,
         if (sm != null) ResponsiveBreakpointKey.sm: sm,
         if (md != null) ResponsiveBreakpointKey.md: md,
         if (lg != null) ResponsiveBreakpointKey.lg: lg,
       };

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<EdgeInsets>(
      builder: (context, padding) => Padding(
        padding: padding,
        child: child,
      ),
      xs: _paddings[ResponsiveBreakpointKey.xs],
      sm: _paddings[ResponsiveBreakpointKey.sm],
      md: _paddings[ResponsiveBreakpointKey.md],
      lg: _paddings[ResponsiveBreakpointKey.lg],
    );
  }
}
