import 'package:flutter/material.dart';

const _kDefaultIndent = 24.0;

/// The [VoicesDivider] widget is a simple wrapper around Material's [Divider]
/// widget that provides additional customization options for indentation.
///
/// It's primarily used to create horizontal dividers within the context
/// of a list or other layout with specific indentation requirements.
class VoicesDivider extends StatelessWidget {
  /// A double value representing the height of the divider.
  ///
  /// See [Divider.height].
  final double? height;

  /// A double value representing the indentation of the divider from the
  /// start of the parent container.
  ///
  /// Defaults to [_kDefaultIndent] (24.0).
  final double indent;

  /// A double value representing the indentation of the divider from the
  /// end of the parent container.
  ///
  /// Defaults to [_kDefaultIndent] (24.0).
  final double endIndent;

  /// Optional color of divider.
  final Color? color;

  const VoicesDivider({
    super.key,
    this.height,
    this.indent = _kDefaultIndent,
    this.endIndent = _kDefaultIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
