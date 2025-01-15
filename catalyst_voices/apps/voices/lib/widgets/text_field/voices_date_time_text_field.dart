import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoicesDateTimeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoicesTextFieldValidator? validator;
  final String hintText;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget suffixIcon;
  final bool dimBorder;
  final BorderRadius borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  const VoicesDateTimeTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    required this.hintText,
    required this.onFieldSubmitted,
    required this.suffixIcon,
    this.dimBorder = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final onFieldSubmitted = this.onFieldSubmitted;

    final borderSide = !dimBorder
        ? BorderSide(
            color: theme.colors.outlineBorderVariant!,
            width: 0.75,
          )
        : BorderSide(
            color: theme.primaryColor,
            width: 2,
          );

    return VoicesTextField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      decoration: VoicesTextFieldDecoration(
        suffixIcon: ExcludeFocus(child: suffixIcon),
        showStatusSuffixIcon: false,
        fillColor: theme.colors.elevationsOnSurfaceNeutralLv1Grey,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
          borderRadius: borderRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
          borderRadius: borderRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
          borderRadius: borderRadius,
        ),
        hintText: hintText,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: theme.colors.textDisabled,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
        errorMaxLines: 3,
      ),
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
    );
  }
}
