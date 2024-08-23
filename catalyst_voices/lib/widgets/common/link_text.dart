import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String data;
  final TextStyle? style;
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
