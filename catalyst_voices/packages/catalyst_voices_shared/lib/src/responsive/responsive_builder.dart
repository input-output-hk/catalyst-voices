import 'package:catalyst_voices_shared/src/responsive/responsive_breakpoint_key.dart';
import 'package:catalyst_voices_shared/src/utils/typedefs.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

// A [ResponsiveBuilder] is a StatelessWidget that is aware about the current
// device breakpoint.
//
// This is an abstract widget that has a required argument [builder] that can
// consume breakpoint-specific data automatically based on breakpoint that is
// detected.
//
// The breakpoint is identified by using the screen width exposed by MediaQuery
// of the context.
//
// The widget accepts an argument for each breakpoint defined in
// [ResponsiveBreakpointKey]. The breakpoint specific [data] is selected when:
// - the breakpoint is detected
// - the breakpoint-specific data argument is present
// As a fallback the widget uses the [other] argument.
// The type of the breakpoint-specific data is generic but constrained to Object
// in order to prevent the use of `dynamic` that can cause run-time crashes.
//
// Example to render a specific string based on the breakpoints:
//
// ```dart
// ResponsiveBuilder<String>(
//   xs: 'Extra small device',
//   sm: 'Small device',
//   md: 'Medium device',
//   lg: 'Large device',
//   other: 'Fallback device',
//   builder: (context, title) => Title(title!),
// );
//
// or to have a specific padding:
//
// ```dart
// ResponsiveBuilder<EdgeInsetsGeometry>(
//   xs: EdgeInsets.all(4.0),
//   other: EdgeInsets.all(10.0),
//   builder: (context, padding) => Padding(
//     padding: padding,
//     child: Text('This is an example.')
//   ),
// );
// ```

const Map<ResponsiveBreakpointKey, ({int min, int max})> _breakpoints = {
  ResponsiveBreakpointKey.xs: (min: 0, max: 599),
  ResponsiveBreakpointKey.sm: (min: 600, max: 1239),
  ResponsiveBreakpointKey.md: (min: 1240, max: 1439),
  ResponsiveBreakpointKey.lg: (min: 1440, max: 2048),
};

class ResponsiveBuilder<T extends Object> extends StatelessWidget {
  final DataWidgetBuilder<T> builder;
  final Map<ResponsiveBreakpointKey, T> _responsiveData;

  ResponsiveBuilder({
    super.key,
    required this.builder,
    T? xs,
    T? sm,
    T? md,
    T? lg,
    required T other,
  }) : _responsiveData = {
          if (xs != null) ResponsiveBreakpointKey.xs: xs,
          if (sm != null) ResponsiveBreakpointKey.sm: sm,
          if (md != null) ResponsiveBreakpointKey.md: md,
          if (lg != null) ResponsiveBreakpointKey.lg: lg,
          ResponsiveBreakpointKey.other: other,
        };

  @override
  Widget build(BuildContext context) {
    return builder(context, _getResponsiveBreakpoint(context));
  }

  T _getResponsiveBreakpoint(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final breakpointKey = _breakpoints.entries
            .where((entry) => _responsiveData.containsKey(entry.key))
            .firstWhereOrNull((entry) => entry.value.contains(screenWidth))
            ?.key ??
        ResponsiveBreakpointKey.other;

    assert(
      _responsiveData.containsKey(breakpointKey),
      'Selected key[$breakpointKey] data is not defined. '
      'Make sure at least .other is not null',
    );

    return _responsiveData[breakpointKey]!;
  }
}

extension _RangeExt on ({int min, int max}) {
  bool contains(double value) => value >= min && value <= max;
}
