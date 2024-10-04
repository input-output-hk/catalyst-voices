import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

// A [ResponsiveChild] is a StatelessWidget that selects a WidgetBuilder based
// on the current screen size and execute it.
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
//   xs: (context) => const Text('Simple text for extra small screens.'),
//   sm: (context) => const Padding(
//     padding: EdgeInsets.all(50),
//       child: Text('Text with padding for small screens.'),
//     ),
//   md: (context) => const Column(
//     children: [
//       Text('This is'),
//       Text('a set'),
//       Text('of Texts'),
//       Text('for medium screens.'),
//     ],
//   ),
//   other: (context) => const Text('The fallback widget.'),
// );
// ```

class ResponsiveChild extends StatelessWidget {
  final Map<ResponsiveBreakpointKey, WidgetBuilder> _widgets;

  ResponsiveChild({
    super.key,
    WidgetBuilder? xs,
    WidgetBuilder? sm,
    WidgetBuilder? md,
    WidgetBuilder? lg,
    required WidgetBuilder other,
  }) : _widgets = {
          if (xs != null) ResponsiveBreakpointKey.xs: xs,
          if (sm != null) ResponsiveBreakpointKey.sm: sm,
          if (md != null) ResponsiveBreakpointKey.md: md,
          if (lg != null) ResponsiveBreakpointKey.lg: lg,
          ResponsiveBreakpointKey.other: other,
        };

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<WidgetBuilder>(
      builder: (context, childBuilder) => childBuilder(context),
      xs: _widgets[ResponsiveBreakpointKey.xs],
      sm: _widgets[ResponsiveBreakpointKey.sm],
      md: _widgets[ResponsiveBreakpointKey.md],
      lg: _widgets[ResponsiveBreakpointKey.lg],
      other: _widgets[ResponsiveBreakpointKey.other]!,
    );
  }
}
