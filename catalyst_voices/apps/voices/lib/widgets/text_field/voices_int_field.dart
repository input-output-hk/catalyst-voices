import 'package:catalyst_voices/widgets/text_field/voices_num_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoicesIntFieldController extends VoicesNumFieldController<int> {
  VoicesIntFieldController([super.value]);
}

class VoicesIntField extends StatelessWidget {
  final VoicesIntFieldController? controller;
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;
  final ValueChanged<int?>? onFieldSubmitted;
  final VoicesTextFieldDecoration? decoration;
  final VoicesNumFieldValidator<int>? validator;

  const VoicesIntField({
    super.key,
    this.controller,
    this.statesController,
    this.focusNode,
    required this.onFieldSubmitted,
    this.decoration,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesNumField<int>(
      codec: const IntCodec(),
      controller: controller,
      statesController: statesController,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      decoration: decoration,
      validator: validator,
      keyboardType: TextInputType.number,
      // Note. int.parse returns incorrect values for bigger Strings.
      // If more is required use BigInt
      maxLength: kIsWeb ? 16 : null,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
