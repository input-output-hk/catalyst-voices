import 'package:flutter/material.dart';

/// Base Voices TextField widget
class VoicesTextField extends StatelessWidget {
  /// [TextField.controller]
  final TextEditingController? controller;

  /// [TextField.focusNode]
  final FocusNode? focusNode;

  /// [TextField.decoration]
  final InputDecoration? decoration;

  /// [TextField.keyboardType]
  final TextInputType? keyboardType;

  /// [TextField.textInputAction]
  final TextInputAction? textInputAction;

  /// [TextField.textCapitalization]
  final TextCapitalization textCapitalization;

  /// [TextField.style]
  final TextStyle? style;

  /// [TextField.obscureText]
  final bool obscureText;

  /// [TextField.onChanged]
  final ValueChanged<String>? onChanged;

  const VoicesTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
