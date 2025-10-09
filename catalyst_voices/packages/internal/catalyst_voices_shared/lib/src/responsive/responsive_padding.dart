import 'package:catalyst_voices_shared/src/responsive/responsive.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/widgets.dart';

/// A [ResponsivePadding] is a StatelessWidget that applies a padding based on
/// the current screen size.
///
/// The widget wraps its [child] in a [ResponsiveBuilder] that calculates the
/// proper padding value based on the screen size and wraps it again in a Padding
/// to display the selected padding value.
///
/// The possible arguments are `xs`, `sm`, `md`, `lg` following the
/// Material design standards and the [ResponsiveBuilder] arguments.
///
/// Example usage:
///
/// ```dart
/// ResponsivePadding(
///   xs: const EdgeInsets.all(4.0),
///   sm: const EdgeInsets.all(6.0),
///   md: const EdgeInsets.only(top: 6.0),
///   lg: const EdgeInsets.symmetric(vertical: 15.0),
///   child: Text('This is an example text with dynamic padding.')
/// );
/// ```
class ResponsivePadding extends StatelessWidget {
  final Responsive<EdgeInsets> responsive;
  final Widget child;

  ResponsivePadding({
    super.key,
    EdgeInsets? xs,
    EdgeInsets? sm,
    EdgeInsets? md,
    EdgeInsets? lg,
    required this.child,
  }) : responsive = Responsive.breakpoints(
         xs: xs,
         sm: sm,
         md: md,
         lg: lg,
       );

  const ResponsivePadding.fromResponsive({
    super.key,
    required this.responsive,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.fromResponsive(
      responsive: responsive,
      builder: (context, padding) => Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
