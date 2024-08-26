import 'package:flutter/material.dart';

/// A widget that displays text with an underline that acts as a link.
///
/// This widget takes three arguments:
///  * `data`: The text to be displayed. (Required)
///  * `style`: An optional TextStyle to customize the appearance of the text.
///  * `onTap`: An optional callback function that will be executed when the
///  user taps on the text.
class LinkText extends StatelessWidget {
  /// The text to be displayed.
  final String data;

  /// An optional TextStyle to customize the appearance of the text.
  final TextStyle? style;

  /// An optional callback function that will be executed when the user taps
  /// on the text.
  final VoidCallback? onTap;

  const LinkText(
    this.data, {
    super.key,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    final effectiveStyle = (style ?? const TextStyle()).copyWith(
      color: color,
      decoration: TextDecoration.underline,
      decorationColor: color,
      decorationStyle: TextDecorationStyle.solid,
    );

    return GestureDetector(
      onTap: onTap,
      child: DefaultTextStyle.merge(
        style: style,
        child: Text(
          data,
          style: effectiveStyle,
        ),
      ),
    );
  }
}
