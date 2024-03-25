import 'package:catalyst_voices_shared/src/responsive_builder/responsive_breakpoint_key.dart';
import 'package:catalyst_voices_shared/src/responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

class ResponsiveDynamicChild extends StatelessWidget {
  final Map<ResponsiveBreakpointKey, Widget?> _widgets;

  ResponsiveDynamicChild({
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
