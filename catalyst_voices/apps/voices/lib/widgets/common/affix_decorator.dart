import 'package:flutter/material.dart';

/// A widget that decorates a child widget with an optional prefix and/or suffix.
///
/// This widget allows you to add an icon or any other widget before (prefix)
/// and/or after (suffix) the child widget, with a customizable gap in between.
///
/// Example
/// ```dart
///     AffixDecorator(
///       iconTheme: IconTheme.of(context).copyWith(size: 18),
///       prefix: leading,
///       suffix: trailing,
///       child: DefaultTextStyle(
///         style: Theme.of(context).textTheme.labelLarge!,
///         child: child,
///       ),
///     )
/// ```
class AffixDecorator extends StatelessWidget {
  /// Allows to place affixes horizontally or vertically.
  final Axis axis;

  /// The spacing between the child widget and the prefix/suffix icons.
  final double gap;

  /// An optional theme to apply to both prefix and suffix icons.
  /// If not provided, inherits the theme from the context.
  final IconThemeData? iconTheme;

  /// The widget to be displayed before the child widget.
  final Widget? prefix;

  /// The widget to be displayed after the child widget.
  final Widget? suffix;

  /// See [Row.mainAxisSize].
  final MainAxisSize mainAxisSize;

  /// The widget to be decorated with prefix and/or suffix.
  final Widget child;

  /// See [Row.crossAxisAlignment].
  final CrossAxisAlignment crossAxisAlignment;

  /// Creates a new instance of PrefixSuffixDecorator.
  ///
  /// At least one of `prefix` or `suffix` should be non-null for the decoration
  /// to be visible.
  const AffixDecorator({
    super.key,
    this.axis = Axis.horizontal,
    this.gap = 8,
    this.iconTheme,
    this.prefix,
    this.suffix,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final suffix = this.suffix;
    final prefix = this.prefix;

    final child = switch (mainAxisSize) {
      MainAxisSize.min => Flexible(
          key: const Key('DecoratorData'),
          child: this.child,
        ),
      MainAxisSize.max => Expanded(
          key: const Key('DecoratorData'),
          child: this.child,
        ),
    };

    return Flex(
      direction: axis,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      spacing: gap,
      children: [
        if (prefix != null)
          IconTheme(
            key: const Key('DecoratorIconBefore'),
            data: iconTheme ?? IconTheme.of(context),
            child: prefix,
          ),
        child,
        if (suffix != null)
          IconTheme(
            key: const Key('DecoratorIconAfter'),
            data: iconTheme ?? IconTheme.of(context),
            child: suffix,
          ),
      ],
    );
  }
}
