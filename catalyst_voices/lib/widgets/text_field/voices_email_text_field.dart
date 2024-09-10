import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

final class VoicesEmailTextField extends StatelessWidget {
  /// Emits new value when widget input changes
  final ValueChanged<String>? onChanged;

  const VoicesEmailTextField({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VoicesTextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      decoration: VoicesTextFieldDecoration(
        labelText: l10n.emailLabelText,
        hintText: l10n.emailHintText,
        errorText: l10n.emailErrorText,
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
