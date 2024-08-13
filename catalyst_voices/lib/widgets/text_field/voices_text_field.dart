import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Base Voices TextField widget
class VoicesTextField extends StatelessWidget {
  /// [TextField.controller]
  final TextEditingController? controller;

  /// [TextField.focusNode]
  final FocusNode? focusNode;

  /// [TextField.decoration]
  final VoicesTextFieldDecoration? decoration;

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

  /// [TextField.maxLines].
  final int? maxLines;

  /// [TextField.minLines].
  final int? minLines;

  /// [TextField.maxLength].
  final int? maxLength;

  /// [TextField.enabled].
  final bool enabled;

  /// [TextField.onChanged]
  final ValueChanged<String>? onChanged;

  const VoicesTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final labelText = decoration?.labelText ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text(
            labelText,
            style: enabled
                ? textTheme.titleSmall
                : textTheme.titleSmall!
                    .copyWith(color: theme.colors.textDisabled),
          ),
          const SizedBox(height: 4),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: decoration?.border ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
            enabledBorder: decoration?.enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
            disabledBorder: decoration?.disabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
            errorBorder: decoration?.errorBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: theme.colorScheme.error,
                  ),
                ),
            focusedBorder: decoration?.focusedBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
            focusedErrorBorder: decoration?.focusedErrorBorder ??
                OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 2, color: theme.colorScheme.error),
                ),
            helperText: decoration?.helperText,
            helperStyle: enabled
                ? textTheme.bodySmall
                : textTheme.bodySmall!
                    .copyWith(color: theme.colors.textDisabled),
            hintText: decoration?.hintText,
            hintStyle: textTheme.bodyLarge,
            errorText: decoration?.errorText,
            errorMaxLines: decoration?.errorMaxLines,
            errorStyle: enabled
                ? textTheme.bodySmall
                : textTheme.bodySmall!
                    .copyWith(color: theme.colors.textDisabled),
            prefixIcon: decoration?.prefixIcon,
            prefixText: decoration?.prefixText,
            suffixIcon: decoration?.suffixIcon,
            suffixText: decoration?.suffixText,
            counterText: decoration?.counterText,
            counterStyle: enabled
                ? textTheme.bodySmall
                : textTheme.bodySmall!
                    .copyWith(color: theme.colors.textDisabled),
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: style,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          enabled: enabled,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// A replacement for [InputDecoration] to only expose parameters
/// that are supported by [VoicesTextField].
class VoicesTextFieldDecoration {
  /// [InputDecoration.border].
  final InputBorder? border;

  /// [InputDecoration.enabledBorder].
  final InputBorder? enabledBorder;

  /// [InputDecoration.disabledBorder].
  final InputBorder? disabledBorder;

  /// [InputDecoration.errorBorder].
  final InputBorder? errorBorder;

  /// [InputDecoration.focusedBorder].
  final InputBorder? focusedBorder;

  /// [InputDecoration.focusedErrorBorder].
  final InputBorder? focusedErrorBorder;

  /// Similar to the [InputDecoration.labelText] but does not use
  /// the floating behavior and is instead above the text field instead.
  final String? labelText;

  /// [InputDecoration.helperText].
  final String? helperText;

  /// [InputDecoration.hintText].
  final String? hintText;

  /// [InputDecoration.errorText].
  final String? errorText;

  /// [InputDecoration.errorMaxLines].
  final int? errorMaxLines;

  /// [InputDecoration.prefixIcon].
  final Widget? prefixIcon;

  /// [InputDecoration.prefixText].
  final String? prefixText;

  /// [InputDecoration.suffixIcon].
  final Widget? suffixIcon;

  /// [InputDecoration.suffixText].
  final String? suffixText;

  /// [InputDecoration.counterText].
  final String? counterText;

  /// Creates a new text field decoration.
  const VoicesTextFieldDecoration({
    this.border,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.labelText,
    this.helperText,
    this.hintText,
    this.errorText,
    this.errorMaxLines,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.suffixText,
    this.counterText,
  });

  /// Creates a text field decoration where all borders are the same.
  const VoicesTextFieldDecoration.singleBorder({
    required this.border,
    this.labelText,
    this.helperText,
    this.hintText,
    this.errorText,
    this.errorMaxLines,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.suffixText,
    this.counterText,
  })  : enabledBorder = border,
        disabledBorder = border,
        errorBorder = border,
        focusedBorder = border,
        focusedErrorBorder = border;
}
