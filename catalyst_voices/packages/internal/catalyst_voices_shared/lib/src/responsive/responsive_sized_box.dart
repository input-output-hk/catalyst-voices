import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/widgets.dart';

/// A [ResponsiveSizedBox] is a StatelessWidget that creates a SizedBox based on
/// the current screen size.
///
/// The widget uses ResponsiveBuilder to calculate the proper SizedBox
/// based on the screen size and returns the appropriate SizedBox widget.
///
/// The possible arguments are xs, sm, md, lg, other following the
/// Material design standards and the ResponsiveBuilder arguments.
class ResponsiveSizedBox extends StatelessWidget {
  final Map<ResponsiveBreakpointKey, SizedBox> _sizedBoxes;

  ResponsiveSizedBox({
    super.key,
    SizedBox xs = const SizedBox(),
    SizedBox sm = const SizedBox(),
    SizedBox md = const SizedBox(),
    SizedBox lg = const SizedBox(),
    SizedBox other = const SizedBox(),
  }) : _sizedBoxes = {
         ResponsiveBreakpointKey.xs: xs,
         ResponsiveBreakpointKey.sm: sm,
         ResponsiveBreakpointKey.md: md,
         ResponsiveBreakpointKey.lg: lg,
         ResponsiveBreakpointKey.other: other,
       };

  factory ResponsiveSizedBox.only({
    Key? key,
    SizedBox? xs,
    SizedBox? sm,
    SizedBox? md,
    SizedBox? lg,
    SizedBox other = const SizedBox.shrink(),
  }) => ResponsiveSizedBox(
    key: key,
    xs: xs ?? other,
    sm: sm ?? other,
    md: md ?? other,
    lg: lg ?? other,
    other: other,
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<SizedBox>(
      builder: (context, sizedBox) => sizedBox,
      xs: _sizedBoxes[ResponsiveBreakpointKey.xs],
      sm: _sizedBoxes[ResponsiveBreakpointKey.sm],
      md: _sizedBoxes[ResponsiveBreakpointKey.md],
      lg: _sizedBoxes[ResponsiveBreakpointKey.lg],
      other: _sizedBoxes[ResponsiveBreakpointKey.other]!,
    );
  }
}
