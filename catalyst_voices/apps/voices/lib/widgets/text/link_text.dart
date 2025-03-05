import 'dart:async';

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// A widget that displays text with an underline that acts as a link.
///
/// This widget takes three arguments:
///  * `data`: The text to be displayed. (Required)
///  * `style`: An optional TextStyle to customize the appearance of the text.
///  * `onTap`: An optional callback function that will be executed when the
///  user taps on the text.
class LinkText extends StatelessWidget with LaunchUrlMixin {
  /// The text to be displayed.
  final String data;

  /// Optional open redirect location.
  final Uri? uri;

  /// If clicking should trigger callback or not.
  final bool enabled;

  /// Displays the text with underline.
  final bool underline;

  /// An optional TextStyle to customize the appearance of the text.
  final TextStyle? style;

  /// An optional callback function that will be executed when the user taps
  /// on the text.
  ///
  /// If not provided will try to open [uri] or parse and open [data].
  final VoidCallback? onTap;

  const LinkText(
    this.data, {
    super.key,
    this.uri,
    this.enabled = true,
    this.underline = true,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    final effectiveStyle = (style ?? const TextStyle()).copyWith(
      color: color,
      decoration: underline ? TextDecoration.underline : null,
      decorationColor: underline ? color : null,
      decorationStyle: underline ? TextDecorationStyle.solid : null,
    );

    return DefaultSelectionStyle(
      mouseCursor: enabled ? SystemMouseCursors.click : null,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.none,
        child: GestureDetector(
          onTap: enabled
              ? onTap ??
                  () {
                    final uri = this.uri ?? Uri.tryParse(data);
                    if (uri != null) {
                      unawaited(launchUri(uri));
                    }
                  }
              : null,
          child: DefaultTextStyle.merge(
            style: style,
            child: Text(
              data,
              style: effectiveStyle,
            ),
          ),
        ),
      ),
    );
  }
}
