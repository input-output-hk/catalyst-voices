import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices/widgets/toggles/voices_radio.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesRadioButtonFormField extends VoicesFormField<String> {
  final List<String> items;

  VoicesRadioButtonFormField({
    super.key,
    required this.items,
    required super.value,
    required super.onChanged,
    super.enabled,
    super.validator,
    super.autovalidateMode = AutovalidateMode.always,
  }) : super(
          builder: (field) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RadioButtonList(
                  enabled: enabled,
                  items: items,
                  onChanged: field.didChange,
                  value: field.value,
                ),
                if (field.hasError)
                  _ErrorText(
                    errorText: field.errorText,
                  ),
              ],
            );
          },
        );
}

class _RadioButtonList extends StatelessWidget {
  final bool enabled;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? value;

  const _RadioButtonList({
    required this.enabled,
    required this.items,
    this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map<Widget>(
              (e) => VoicesRadio<String>(
                key: ValueKey(e),
                value: e,
                label: Text(
                  e,
                  style: getStyle(context, e),
                ),
                groupValue: value,
                onChanged: onChanged,
              ),
            )
            .separatedBy(const SizedBox(height: 10))
            .toList(),
      ),
    );
  }

  TextStyle? getStyle(BuildContext context, String? itemValue) {
    final textStyle = context.textTheme.bodyLarge;
    if (enabled || value == itemValue) {
      return textStyle;
    }
    return textStyle?.copyWith(
      color: context.colors.textDisabled,
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String? errorText;

  const _ErrorText({
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        errorText ?? context.l10n.snackbarErrorLabelText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
