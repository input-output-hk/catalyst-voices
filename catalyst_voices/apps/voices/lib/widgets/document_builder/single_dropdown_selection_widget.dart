import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
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
  late List<DropdownMenuEntry<String>> _dropdownMenuEntries;
  late String? _selectedValue;

  String get _title => widget.schema.formattedTitle;

  List<DropdownMenuEntry<String>> get _mapItems {
    final items = widget.schema.enumValues ?? [];
    return items.map((e) => DropdownMenuEntry(value: e, label: e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _handleInitialValue();
  }

  @override
  void didUpdateWidget(covariant SingleDropdownSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      _handleInitialValue();
    }

    if (oldWidget.property.value != widget.property.value) {
      _handleInitialValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SingleSelectDropdown(
          items: _dropdownMenuEntries,
          value: _selectedValue,
          onChanged: _handleValueChanged,
          validator: _validator,
          enabled: widget.isEditMode,
        ),
      ],
    );
  }

  void _handleInitialValue() {
    _selectedValue = widget.property.value;
    _dropdownMenuEntries = _mapItems;
  }

  void _handleValueChanged(String? value) {
    setState(() {
      _selectedValue = value;
    });

    if (widget.property.value != value) {
      _notifyChangeListener(value);
    }
  }

  void _notifyChangeListener(String? value) {
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
