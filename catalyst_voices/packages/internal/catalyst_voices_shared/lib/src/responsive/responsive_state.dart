import 'dart:ui';

import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:collection/collection.dart';

/// A default implementation of the [ResponsiveState].
///
/// Assigns a data to each [ResponsiveBreakpointKey] and attemps to find
/// the best matching breakpoint given the screen size.
final class ResponsiveMapState<T extends Object>
    with ResponsiveStateResolver<T>
    implements ResponsiveState<T> {
  @override
  final Map<ResponsiveBreakpointKey, T> breakpointsData;

  @override
  final T? fallback;

  ResponsiveMapState({
    T? xs,
    T? sm,
    T? md,
    T? lg,
    T? other,
  }) : this.fromData(
         {
           if (xs != null) ResponsiveBreakpointKey.xs: xs,
           if (sm != null) ResponsiveBreakpointKey.sm: sm,
           if (md != null) ResponsiveBreakpointKey.md: md,
           if (lg != null) ResponsiveBreakpointKey.lg: lg,
         },
         fallback: other,
       );

  ResponsiveMapState.fromData(
    this.breakpointsData, {
    this.fallback,
  }) : assert(
         breakpointsData.isNotEmpty || fallback != null,
         'Either breakpointsData must be provided or fallback.',
       );
}

//ignore: one_member_abstracts
abstract interface class ResponsiveState<T extends Object> {
  /// Provides responsive data based on the given [screenSize].
  ///
  /// Implementations return the appropriate value for the current screen dimensions.
  T resolve(Size screenSize);
}

mixin ResponsiveStateResolver<T extends Object> implements ResponsiveState<T> {
  /// Mapping of responsive breakpoints to their associated data.
  Map<ResponsiveBreakpointKey, T> get breakpointsData;

  /// Fallback data used when no exact match is found in [breakpointsData].
  ///
  /// If null, the best matching breakpoint will be resolved instead.
  T? get fallback;

  @override
  T resolve(Size screenSize) {
    assert(
      breakpointsData.isNotEmpty,
      'Either breakpointsData must be provided or fallback.',
    );

    final exactMatch = _findExactMatch(screenSize);
    if (exactMatch != null) {
      return exactMatch;
    }

    final fallback = this.fallback;
    if (fallback != null) {
      return fallback;
    }

    return _findBestMatch(screenSize)!;
  }

  /// Finds the most suitable breakpoint for the given [screenSize].
  ///
  /// Chooses the largest breakpoint whose range includes the screen width.
  /// If none match, falls back to the closest smaller breakpoint.
  T? _findBestMatch(Size screenSize) {
    final breakpoints = List.of(ResponsiveBreakpointKey.values)..sortBy((a) => a.range.max);
    final breakpointsBiggestToSmallest = breakpoints.reversed.toList();
    final width = screenSize.width;

    for (final breakpoint in breakpointsBiggestToSmallest) {
      final data = breakpointsData[breakpoint];
      if (data == null) continue;
      if (breakpoint.range.min > width) continue;
      if (breakpoint.range.contains(width)) return data;
      if (breakpoint.range.max < width) return data;
    }

    return breakpointsData.values.firstOrNull;
  }

  /// Finds a breakpoint which range exactly matches the [screenSize].
  T? _findExactMatch(Size screenSize) {
    final width = screenSize.width;
    final key = ResponsiveBreakpointKey.values.firstWhereOrNull(
      (breakpoint) => breakpoint.range.contains(width),
    );
    return breakpointsData[key];
  }
}
