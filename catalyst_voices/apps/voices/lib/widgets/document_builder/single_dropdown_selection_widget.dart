import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SingleDropdownSelectionWidget extends StatefulWidget {
  final DocumentValueProperty<String> property;
  final DocumentDropDownSingleSelectSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const SingleDropdownSelectionWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<SingleDropdownSelectionWidget> createState() =>
      _SingleDropdownSelectionWidgetState();
}

class _SingleDropdownSelectionWidgetState
    extends State<SingleDropdownSelectionWidget> {
  String get _title => widget.schema.title;
  bool get _isRequired => widget.schema.isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title.starred(isEnabled: _isRequired),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        SingleSelectDropdown(
          items: _buildMenuEntries(),
          value: widget.property.value ?? widget.schema.defaultValue,
          onChanged: _onChanged,
          validator: _validator,
          readOnly: !widget.isEditMode,
        ),
      ],
    );
  }

  List<DropdownMenuEntry<String>> _buildMenuEntries() {
    final items = widget.schema.enumValues ?? [];
    return items.map((e) => DropdownMenuEntry(value: e, label: e)).toList();
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
    final result = schema.validate(normalizedValue);

    return LocalizedDocumentValidationResult.from(result).message(context);
  }
}
