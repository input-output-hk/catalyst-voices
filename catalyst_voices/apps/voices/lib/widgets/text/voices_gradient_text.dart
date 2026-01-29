import 'package:flutter/material.dart';

/// Creates a [Text] with [gradient] fill.
class VoicesGradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle? style;

  const VoicesGradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // ShaderMask requires a white color mask to apply.
    final textStyle = (style ?? const TextStyle()).copyWith(color: Colors.white);

    return ShaderMask(
      shaderCallback: gradient.createShader,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
