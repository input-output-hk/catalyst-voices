import 'package:flutter/material.dart';

const _kDefaultIntent = 24.0;

/// Simple wrapper on Material [Divider].
class VoicesDivider extends StatelessWidget {
  final double indent;
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
