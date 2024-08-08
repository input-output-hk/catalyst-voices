import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

final class VoicesPasswordTextField extends StatelessWidget {
  /// Emits new value when widget input changes
  final ValueChanged<String>? onChanged;

  const VoicesPasswordTextField({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VoicesTextField(
      keyboardType: TextInputType.multiline,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        errorMaxLines: 2,
        labelText: l10n.passwordLabelText,
        hintText: l10n.passwordHintText,
        errorText: l10n.passwordErrorText,
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
