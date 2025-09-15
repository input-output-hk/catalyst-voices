import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';

/// A [ResponsiveBuilder] is a StatelessWidget that is aware about the current
/// device breakpoint.
///
/// This is an abstract widget that has a required argument [builder] that can
/// consume breakpoint-specific data automatically based on breakpoint that is
/// detected.
///
/// The breakpoint is identified by using the screen size exposed by [MediaQuery]
/// of the context. [Responsive.resolve] is responsible for resolving the best matching value
/// for a given breakpoint.
///
/// Example usage:
/// 
/// ```dart
/// ResponsiveBuilder<String>(
///   xs: 'Extra small device',
///   sm: 'Small device',
///   md: 'Medium device',
///   lg: 'Large device',
///   builder: (context, title) => Title(title),
/// );
/// ```
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
