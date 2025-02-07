import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/toggles/voices_radio_button_form_field.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RadioButtonSelectWidget extends StatefulWidget {
  final DocumentValueProperty<String> property;
  final DocumentRadioButtonSelect schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const RadioButtonSelectWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<RadioButtonSelectWidget> createState() =>
      _RadioButtonSelectionWidgetState();
}

class _RadioButtonSelectionWidgetState extends State<RadioButtonSelectWidget> {
  List<String> get _items => widget.schema.enumValues ?? <String>[];
  String get _title => widget.schema.title;
  bool get _isRequired => widget.schema.isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title.starred(isEnabled: _isRequired),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          VoicesRadioButtonFormField(
            items: _items,
            value: widget.property.value ?? widget.schema.defaultValue,
            onChanged: _onChanged,
            enabled: widget.isEditMode,
            validator: _validator,
          ),
        ],
      ],
    );
  }

  void _onChanged(String? value) {
    final normalizedValue = widget.schema.normalizeValue(value);
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: normalizedValue,
    );
    widget.onChanged([change]);
  }

  String? _validator(String? value) {
    final schema = widget.schema;
    final normalizedValue = schema.normalizeValue(value);
    final result = widget.schema.validate(normalizedValue);
    return LocalizedDocumentValidationResult.from(result).message(context);
  }
}
