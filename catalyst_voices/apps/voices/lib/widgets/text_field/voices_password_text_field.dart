import 'package:catalyst_voices/common/formatters/input_formatters.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class VoicesPasswordTextField extends StatelessWidget {
  /// [VoicesTextField.controller].
  final TextEditingController? controller;

  /// [VoicesTextField.textInputAction].
  final TextInputAction textInputAction;

  /// Emits new value when widget input changes.
  final ValueChanged<String>? onChanged;

  /// Calls event to end some actions using for example enter key
  final ValueChanged<String>? onSubmitted;

  /// Optional decoration. See [VoicesTextField] for more details.
  final VoicesTextFieldDecoration? decoration;

  /// [VoicesTextField.autofocus].
  final bool autofocus;

  const VoicesPasswordTextField({
    super.key,
    this.controller,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onSubmitted,
    this.decoration,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextField(
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      autofocus: autofocus,
      obscureText: true,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: decoration,
      inputFormatters: [
        FilteringTextInputFormatter.singleLineFormatter,
        NoWhitespacesFormatter(),
      ],
    );
  }
}
