import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class VoicesDisplayNameTextField extends VoicesTextField {
  VoicesDisplayNameTextField({
    super.key,
    super.initialText,
    super.controller,
    super.focusNode,
    super.onChanged,
    required super.onFieldSubmitted,
    super.onEditingComplete,
    super.textInputAction = TextInputAction.next,
    super.decoration,
    super.readOnly = false,
    super.maxLength,
  }) : super(
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
          ],
        );
}
