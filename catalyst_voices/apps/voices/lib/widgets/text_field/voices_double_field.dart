import 'package:catalyst_voices/widgets/text_field/voices_num_field.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/services.dart';

class VoicesDoubleField extends VoicesNumField<double> {
  VoicesDoubleField({
    super.key,
    VoicesDoubleFieldController? super.controller,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.validator,
    required super.onFieldSubmitted,
    List<TextInputFormatter>? inputFormatters,
    int? decimalDigits,
    super.enabled,
    super.readOnly,
    super.ignorePointers,
  }) : super(
         codec: const DoubleCodec(),
         keyboardType: const TextInputType.numberWithOptions(decimal: true),
         inputFormatters: [
           DecimalTextInputFormatter(
             maxIntegerDigits: NumberUtils.maxSafeIntDigits,
             maxDecimalDigits: decimalDigits,
           ),
           ...?inputFormatters,
         ],
       );
}

class VoicesDoubleFieldController extends VoicesNumFieldController<double> {
  VoicesDoubleFieldController([super.value]);
}
