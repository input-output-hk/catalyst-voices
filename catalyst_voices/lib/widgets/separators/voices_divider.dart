import 'package:flutter/material.dart';

const _kDefaultIntent = 24.0;

/// The [VoicesDivider] widget is a simple wrapper around Material's [Divider]
/// widget that provides additional customization options for indentation.
///
/// It's primarily used to create horizontal dividers within the context
/// of a list or other layout with specific indentation requirements.
class VoicesDivider extends StatelessWidget {
  /// A double value representing the indentation of the divider from the
  /// start of the parent container.
  ///
  /// Defaults to [_kDefaultIntent] (24.0).
  final double indent;

  /// A double value representing the indentation of the divider from the
  /// end of the parent container.
  ///
  /// Defaults to [_kDefaultIntent] (24.0).
  final double endIntent;

  const VoicesDivider({
    super.key,
    this.indent = _kDefaultIntent,
    this.endIntent = _kDefaultIntent,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: indent,
      endIndent: endIntent,
    );
  }
}
