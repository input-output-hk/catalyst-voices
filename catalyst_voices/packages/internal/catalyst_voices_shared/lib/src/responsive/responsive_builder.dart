import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
class ResponsiveBuilder<T extends Object> extends StatelessWidget {
  final Responsive<T> responsive;
  final DataWidgetBuilder<T> builder;

  ResponsiveBuilder({
    super.key,
    T? xs,
    T? sm,
    T? md,
    T? lg,
    required this.builder,
  }) : responsive = Responsive.breakpoints(
         xs: xs,
         sm: sm,
         md: md,
         lg: lg,
       );

  const ResponsiveBuilder.fromResponsive({
    super.key,
    required this.responsive,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, _getResponsiveBreakpoint(context));
  }

  T _getResponsiveBreakpoint(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return responsive.resolve(screenSize);
  }
}
