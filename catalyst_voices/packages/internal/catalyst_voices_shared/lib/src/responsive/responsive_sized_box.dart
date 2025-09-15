import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/widgets.dart';

/// A [ResponsiveSizedBox] is a StatelessWidget that creates a [SizedBox] based on
/// the current screen size.
///
/// The widget uses [ResponsiveBuilder] to calculate the proper [SizedBox]
/// based on the screen size and returns the appropriate [SizedBox] widget.
///
/// The possible arguments are `xs`, `sm`, `md` and `lg` following the
/// Material design standards and the ResponsiveBuilder arguments.
class ResponsiveSizedBox extends StatelessWidget {
  final Map<ResponsiveBreakpointKey, SizedBox> _sizedBoxes;

  ResponsiveSizedBox({
    super.key,
    SizedBox? xs,
    SizedBox? sm,
    SizedBox? md,
    SizedBox? lg,
  }) : _sizedBoxes = {
         if (xs != null) ResponsiveBreakpointKey.xs: xs,
         if (sm != null) ResponsiveBreakpointKey.sm: sm,
         if (md != null) ResponsiveBreakpointKey.md: md,
         if (lg != null) ResponsiveBreakpointKey.lg: lg,
       };

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<SizedBox>(
      builder: (context, sizedBox) => sizedBox,
      xs: _sizedBoxes[ResponsiveBreakpointKey.xs],
      sm: _sizedBoxes[ResponsiveBreakpointKey.sm],
      md: _sizedBoxes[ResponsiveBreakpointKey.md],
      lg: _sizedBoxes[ResponsiveBreakpointKey.lg],
    );
  }
}
