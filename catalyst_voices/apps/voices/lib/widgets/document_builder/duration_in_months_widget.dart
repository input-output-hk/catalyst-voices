import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DurationInMonthsWidget extends StatefulWidget {
  final DocumentValueProperty<int> property;
  final DocumentDurationInMonthsSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const DurationInMonthsWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<DurationInMonthsWidget> createState() => _DurationInMonthsWidgetState();
}

class _DurationInMonthsWidgetState extends State<DurationInMonthsWidget> {
  late List<DropdownMenuEntry<int>> _dropdownMenuEntries;
  late int? _selectedValue;

  String get _title => widget.schema.formattedTitle;

  int get _min => widget.schema.numRange?.min ?? 0;

  int get _max => widget.schema.numRange?.max ?? 0;

  List<DropdownMenuEntry<int>> get _mapItems {
    final items = <DropdownMenuEntry<int>>[];
    for (var i = _min; i <= _max; i++) {
      items.add(DropdownMenuEntry(value: i, label: '$i'));
    }

    return items;
  }

  @override
  void initState() {
    super.initState();
    _handleInitialValue();
  }

  @override
  void didUpdateWidget(DurationInMonthsWidget oldWidget) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SingleSelectDropdown(
            items: _dropdownMenuEntries,
            onChanged: _handleValueChanged,
            validator: _validator,
            initialValue: _selectedValue,
            enabled: widget.isEditMode,
          ),
        ],
      ],
    );
  }

  void _handleInitialValue() {
    _selectedValue = widget.property.value;
    _dropdownMenuEntries = _mapItems;
  }

  void _handleValueChanged(int? value) {
    setState(() {
      _selectedValue = value;
    });

    if (widget.property.value != value) {
      _notifyChangeListener(value);
    }
  }

  void _notifyChangeListener(int? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: value,
    );
    widget.onChanged([change]);
  }

  String? _validator(int? value) {
    final result = widget.schema.validate(value);

    return LocalizedDocumentValidationResult.from(result).message(context);
  }
}
