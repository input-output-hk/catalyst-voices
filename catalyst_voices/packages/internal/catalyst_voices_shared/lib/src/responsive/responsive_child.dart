import 'package:catalyst_voices_shared/src/responsive/responsive.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

/// A [ResponsiveChild] is a StatelessWidget that selects a [Widget] child
/// based on the current screen size.
///
/// The possible arguments are `xs`, `sm`, `md`, `lg` following the
/// Material design standards and the [ResponsiveBuilder] arguments.
///
/// Example usage:
///
/// ```dart
/// ResponsiveChild(
///   xs: const SizedBox(width: 16.0),
///   sm: const SizedBox(width: 32.0),
/// );
class ResponsiveChild extends StatelessWidget {
  final Responsive<Widget> responsive;

  ResponsiveChild({
    super.key,
    Widget? xs,
    Widget? sm,
    Widget? md,
    Widget? lg,
  }) : responsive = Responsive.breakpoints(
         xs: xs,
         sm: sm,
         md: md,
         lg: lg,
       );

  const ResponsiveChild.fromResponsive({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.fromResponsive(
      responsive: responsive,
      builder: (context, child) => child,
    );
  }
}
