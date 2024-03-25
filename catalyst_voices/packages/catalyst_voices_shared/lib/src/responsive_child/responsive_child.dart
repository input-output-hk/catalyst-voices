import 'package:catalyst_voices_shared/src/responsive_builder/responsive_breakpoint_key.dart';
import 'package:catalyst_voices_shared/src/responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

// A [ResponsiveChild] is a StatelessWidget that displays a Widget based on the 
// current screen size.
// This is a simple wrapper around ResponsiveBuilder to simplify development and
// make it explicit for a reader.
//
// The possible arguments are [xs], [sm], [md], [lg], [other] following the 
// the ResponsiveBuilder arguments.
// [other] is required and acts as fallback.
//
// Example usage:
// 
// ```dart
// ResponsiveChild(
//   xs: const Text('Simple text for extra small screens.'),
//   sm: const Padding(
//     padding: EdgeInsets.all(50),
//       child: Text('Text with padding for small screens.'),
//     ),
//   md: const Column(
//     children: [
//       Text('This is'),
//       Text('a set'),
//       Text('of Texts'),
//       Text('for medium screens.'),
//     ],
//   ),
//   other: const Text('The fallback widget.'),
// );
// ```

class ResponsiveChild extends StatelessWidget {
  final Map<ResponsiveBreakpointKey, Widget?> _widgets;

  ResponsiveChild({
    super.key,
    Widget? xs,
    Widget? sm,
    Widget? md,
    Widget? lg,
    required Widget other,
  }) : _widgets = {
    ResponsiveBreakpointKey.xs: xs,
    ResponsiveBreakpointKey.sm: sm,
    ResponsiveBreakpointKey.md: md,
    ResponsiveBreakpointKey.lg: lg,
    ResponsiveBreakpointKey.other: other,
  };

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<Widget>(
      builder: (context, child) => child!,
      xs: _widgets[ResponsiveBreakpointKey.xs],
      sm: _widgets[ResponsiveBreakpointKey.sm],
      md: _widgets[ResponsiveBreakpointKey.md],
      lg: _widgets[ResponsiveBreakpointKey.lg],
      other: _widgets[ResponsiveBreakpointKey.other]!,
    );
  }
}
