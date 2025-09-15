import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:flutter/widgets.dart';

class ResponsiveBoxConstraints extends BoxConstraints
    with ResponsiveStateResolver<BoxConstraints>
    implements ResponsiveState<BoxConstraints> {
  @override
  final Map<ResponsiveBreakpointKey, BoxConstraints> breakpointsData;

  ResponsiveBoxConstraints({
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
    BoxConstraints? xs,
    BoxConstraints? sm,
    BoxConstraints? md,
    BoxConstraints? lg,
  }) : breakpointsData = {
         if (xs != null) ResponsiveBreakpointKey.xs: xs,
         if (sm != null) ResponsiveBreakpointKey.sm: sm,
         if (md != null) ResponsiveBreakpointKey.md: md,
         if (lg != null) ResponsiveBreakpointKey.lg: lg,
       };

  ResponsiveBoxConstraints.adapt(BoxConstraints other)
    : this(
        minWidth: other.minWidth,
        maxWidth: other.maxWidth,
        minHeight: other.minHeight,
        maxHeight: other.maxHeight,
      );

  ResponsiveBoxConstraints.from({
    required BoxConstraints fallback,
    BoxConstraints? xs,
    BoxConstraints? sm,
    BoxConstraints? md,
    BoxConstraints? lg,
  }) : this(
         minWidth: fallback.minWidth,
         maxWidth: fallback.maxWidth,
         minHeight: fallback.minHeight,
         maxHeight: fallback.maxHeight,
         xs: xs,
         sm: sm,
         md: md,
         lg: lg,
       );

  @override
  BoxConstraints get fallback => this;
}

extension BoxConstraintsAdapter on BoxConstraints {
  ResponsiveBoxConstraints toResponsive() {
    final instance = this;
    return instance is ResponsiveBoxConstraints
        ? instance
        : ResponsiveBoxConstraints.adapt(instance);
  }
}
