import 'dart:ui';

import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:collection/collection.dart';

//ignore: one_member_abstracts
abstract interface class Responsive<T extends Object> {
  const factory Responsive.breakpoints({
    T? xs,
    T? sm,
    T? md,
    T? lg,
  }) = _ResponsiveBreakpoints;

  const factory Responsive.single(T value) = _SingleResponsive;

  /// Provides responsive data based on the given [screenSize].
  ///
  /// Implementations return the appropriate value for the current screen dimensions.
  T resolve(Size screenSize);
}

/// A default implementation of the [Responsive].
///
/// Assigns a data to each [ResponsiveBreakpointKey] and attemps to find
/// the best matching breakpoint given the screen size.
final class _ResponsiveBreakpoints<T extends Object> implements Responsive<T> {
  final T? xs;
  final T? sm;
  final T? md;
  final T? lg;

  const _ResponsiveBreakpoints({
    this.xs,
    this.sm,
    this.md,
    this.lg,
  }) : assert(
         xs != null || sm != null || md != null || lg != null,
         'At least one of the breakpoints must be given.',
       );

  /// Finds the most suitable breakpoint for the given [screenSize].
  ///
  /// Chooses the largest breakpoint whose range includes the screen width.
  /// If none match, falls back to the closest smaller breakpoint.
  @override
  T resolve(Size screenSize) {
    final breakpointsData = {
      ResponsiveBreakpointKey.xs: xs,
      ResponsiveBreakpointKey.sm: sm,
      ResponsiveBreakpointKey.md: md,
      ResponsiveBreakpointKey.lg: lg,
    };

    final breakpointsSmallestToBiggest = List.of(ResponsiveBreakpointKey.values)
      ..sortBy((a) => a.range.max);
    final breakpointsBiggestToSmallest = breakpointsSmallestToBiggest.reversed.toList();
    final width = screenSize.width;

    for (final breakpoint in breakpointsBiggestToSmallest) {
      final data = breakpointsData[breakpoint];
      if (data == null) continue;
      if (breakpoint.range.min > width) continue;
      if (breakpoint.range.contains(width)) return data;
      if (breakpoint.range.max < width) return data;
    }

    final fallbackBreakpoint = breakpointsSmallestToBiggest.firstWhereOrNull(
      (e) => breakpointsData[e] != null,
    );
    return breakpointsData[fallbackBreakpoint]!;
  }
}

final class _SingleResponsive<T extends Object> implements Responsive<T> {
  final T data;

  const _SingleResponsive(this.data);

  @override
  T resolve(Size screenSize) => data;
}
