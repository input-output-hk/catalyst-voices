import 'package:catalyst_voices/widgets/document_builder/common/document_property_builder_title.dart';
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
  bool get _isRequired => widget.schema.isRequired;
  int get _max => widget.schema.numRange?.max ?? 0;
  int get _min => widget.schema.numRange?.min ?? 0;
  String? get _placeholder => widget.schema.placeholder;
  String get _title => widget.schema.title;
  int? get _value => widget.property.value ?? widget.schema.defaultValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_title.isNotEmpty) ...[
          DocumentPropertyBuilderTitle(
            title: _title,
            isRequired: _isRequired,
          ),
          const SizedBox(height: 8),
          SingleSelectDropdown(
            items: _buildMenuEntries().toList(),
            onChanged: _onChanged,
            validator: _validator,
            value: _value,
            enabled: widget.isEditMode,
            hintText: _placeholder,
          ),
        ],
      ],
    );
  }

  Iterable<DropdownMenuEntry<int>> _buildMenuEntries() sync* {
    for (var i = _min; i <= _max; i++) {
      yield DropdownMenuEntry(value: i, label: '$i');
    }
  }

  void _onChanged(int? value) {
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
