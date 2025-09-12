import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';

/// A [ResponsiveBuilder] is a StatelessWidget that is aware about the current
/// device breakpoint.
///
/// This is an abstract widget that has a required argument [builder] that can
/// consume breakpoint-specific data automatically based on breakpoint that is
/// detected.
///
/// The breakpoint is identified by using the screen size exposed by MediaQuery
/// of the context.
///
/// [ResponsiveState] is responsible for resolving the appropriate value for a given breakpoint.
///
/// Example to render a specific string based on the breakpoints:
///
/// ```dart
/// ResponsiveBuilder<String>(
///   xs: 'Extra small device',
///   sm: 'Small device',
///   md: 'Medium device',
///   lg: 'Large device',
///   other: 'Fallback device',
///   builder: (context, title) => Title(title!),
/// );
///
/// or to have a specific padding:
///
/// ```dart
/// ResponsiveBuilder<EdgeInsetsGeometry>(
///   xs: EdgeInsets.all(4.0),
///   other: EdgeInsets.all(10.0),
///   builder: (context, padding) => Padding(
///     padding: padding,
///     child: Text('This is an example.')
///   ),
/// );
/// ```
// TODO(damian-molinski): support logical operation like < sm or >= md
class ResponsiveBuilder<T extends Object> extends StatelessWidget {
  final DataWidgetBuilder<T> builder;
  final ResponsiveState<T> responsiveState;

  ResponsiveBuilder({
    super.key,
    required this.builder,
    T? xs,
    T? sm,
    T? md,
    T? lg,
    required T other,
  }) : responsiveState = ResponsiveMapState(
         xs: xs,
         sm: sm,
         md: md,
         lg: lg,
         other: other,
       );

  const ResponsiveBuilder.fromState({
    super.key,
    required this.builder,
    required this.responsiveState,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, _getResponsiveBreakpoint(context));
  }

  T _getResponsiveBreakpoint(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return responsiveState.resolve(screenSize);
  }
}
