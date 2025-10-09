import 'package:catalyst_voices/widgets/text_field/voices_num_field.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/services.dart';

class VoicesIntField extends VoicesNumField<int> {
  VoicesIntField({
    super.key,
    VoicesIntFieldController? super.controller,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.validator,
    required super.onFieldSubmitted,
    List<TextInputFormatter>? inputFormatters,
    super.enabled,
    super.readOnly,
    super.ignorePointers,
  }) : super(
         codec: const IntCodec(),
         keyboardType: TextInputType.number,
         inputFormatters: [
           FilteringTextInputFormatter.digitsOnly,
           // int.parse returns incorrect values for bigger Strings. If more is required use BigInt.
           // On web integers can represent numbers up to 2^53.
           // See: https://dart.dev/resources/language/number-representation#dart-number-representation
           LengthLimitingTextInputFormatter(16),
           ...?inputFormatters,
         ],
       );
}

class VoicesIntFieldController extends VoicesNumFieldController<int> {
  VoicesIntFieldController([super.value]);
}
