import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/document_builder/common/document_error_text.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices/widgets/toggles/voices_radio.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesRadioButtonFormField extends VoicesFormField<String> {
  VoicesRadioButtonFormField({
    super.key,
    required super.value,
    required super.onChanged,
    super.enabled,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    required List<String> items,
  }) : super(
         builder: (field) {
           void onChangedHandler(String? groupValue) {
             field.didChange(groupValue);
             onChanged?.call(groupValue);
           }

           return Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               _RadioButtonList(
                 enabled: enabled,
                 items: items,
                 onChanged: onChangedHandler,
                 groupValue: field.value,
               ),
               if (field.hasError) ...[
                 const SizedBox(height: 4),
                 DocumentErrorText(
                   text: field.errorText,
                   enabled: enabled,
                 ),
               ],
             ],
           );
         },
       );
}

class _RadioButtonList extends StatelessWidget {
  final bool enabled;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? groupValue;

  const _RadioButtonList({
    required this.enabled,
    required this.items,
    this.onChanged,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      onChanged: _changeGroupValue,
      groupValue: groupValue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map<Widget>(
              (e) => VoicesRadio<String>(
                key: ValueKey(e),
                label: Text(
                  e,
                  style: getStyle(context, e),
                ),
                value: e,
                enabled: enabled,
              ),
            )
            .separatedBy(const SizedBox(height: 10))
            .toList(),
      ),
    );
  }

  TextStyle? getStyle(BuildContext context, String? itemValue) {
    final textStyle = context.textTheme.bodyLarge;
    if (enabled || groupValue == itemValue) {
      return textStyle;
    }
    return textStyle?.copyWith(
      color: context.colors.textOnPrimaryLevel1,
    );
  }

  void _changeGroupValue(String? value) {
    final onChanged = this.onChanged;

    if (groupValue != value) {
      onChanged?.call(value);
    }
  }
}
