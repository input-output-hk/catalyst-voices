import 'dart:ui';

import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:collection/collection.dart';

class ResponsiveMapState<T extends Object>
    with ResponsiveStateResolver<T>
    implements ResponsiveState<T> {
  @override
  final Map<ResponsiveBreakpointKey, T> breakpointsData;
  @override
  final T fallback;

  ResponsiveMapState({
    T? xs,
    T? sm,
    T? md,
    T? lg,
    required T other,
  }) : this.fromData(
         {
           if (xs case final value?) ResponsiveBreakpointKey.xs: value,
           if (sm case final value?) ResponsiveBreakpointKey.sm: value,
           if (md case final value?) ResponsiveBreakpointKey.md: value,
           if (lg case final value?) ResponsiveBreakpointKey.lg: value,
         },
         fallback: other,
       );

  ResponsiveMapState.fromData(
    this.breakpointsData, {
    required this.fallback,
  });
}

//ignore: one_member_abstracts
abstract class ResponsiveState<T extends Object> {
  T resolve(Size screenSize);
}

mixin ResponsiveStateResolver<T extends Object> implements ResponsiveState<T> {
  Map<ResponsiveBreakpointKey, T> get breakpointsData;

  T get fallback;

  @override
  T resolve(Size screenSize) {
    final width = screenSize.width;
    final breakpointKey = ResponsiveBreakpointKey.values.firstWhereOrNull(
      (breakpoint) => breakpoint.range.contains(width),
    );

    return breakpointsData[breakpointKey] ?? fallback;
  }
}
