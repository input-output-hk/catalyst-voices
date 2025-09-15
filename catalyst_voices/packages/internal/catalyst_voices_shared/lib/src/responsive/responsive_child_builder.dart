import 'package:catalyst_voices_shared/src/responsive/responsive.dart';
import 'package:catalyst_voices_shared/src/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';

/// A [ResponsiveChildBuilder] is a StatelessWidget that selects a [WidgetBuilder] based
/// on the current screen size and execute it.
/// This is a simple wrapper around [ResponsiveBuilder] to simplify development and
/// make it explicit for a reader.
///
/// The possible arguments are `xs`, `sm`, `md`, `lg` following the
/// the [ResponsiveBuilder] arguments.
///
/// If no exact match found in the provided breakpoints the implementation
/// will attempt to find the best matching breakpoint for given screen size.
///
/// Example usage:
///
/// ```dart
/// ResponsiveChild(
///   xs: (context) => const Text('Simple text for extra small screens.'),
///   sm: (context) => const Padding(
///     padding: EdgeInsets.all(50),
///       child: Text('Text with padding for small screens.'),
///     ),
///   md: (context) => const Column(
///     children: [
///       Text('This is'),
///       Text('a set'),
///       Text('of Texts'),
///       Text('for medium screens.'),
///     ],
///   ),
/// );
/// ```
class ResponsiveChildBuilder extends StatelessWidget {
  final Responsive<WidgetBuilder> responsive;

  ResponsiveChildBuilder({
    super.key,
    WidgetBuilder? xs,
    WidgetBuilder? sm,
    WidgetBuilder? md,
    WidgetBuilder? lg,
  }) : responsive = Responsive.breakpoints(
         xs: xs,
         sm: sm,
         md: md,
         lg: lg,
       );

  const ResponsiveChildBuilder.fromResponsive({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.fromResponsive(
      responsive: responsive,
      builder: (context, childBuilder) => childBuilder(context),
    );
  }
}
