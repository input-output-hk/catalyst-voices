import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class VoicesDisplayNameTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final VoicesTextFieldDecoration? decoration;
  final int? maxLength;

  const VoicesDisplayNameTextField({
    super.key,
    this.onChanged,
    required this.onFieldSubmitted,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.next,
    this.decoration,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      decoration: decoration,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
      maxLength: maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.singleLineFormatter,
      ],
    );
  }
}
