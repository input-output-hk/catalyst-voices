import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

class LanguageCodeWidget extends StatefulWidget {
  final DocumentValueProperty<String> property;
  final DocumentLanguageCodeSchema schema;
  final bool isEditMode;

  final ValueChanged<List<DocumentChange>> onChanged;

  const LanguageCodeWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<LanguageCodeWidget> createState() => _LanguageCodeWidgetState();
}

class _LanguageCodeWidgetState extends State<LanguageCodeWidget> {
  late List<DropdownMenuEntry<String>> _dropdownMenuEntries;
  late String? _selectedValue;

  String get _title => widget.schema.formattedTitle;

  List<DropdownMenuEntry<String>> get _mapItems {
    return (widget.schema.enumValues ?? [])
        .map((e) {
          final label = _getLocalizedLanguageName(e);
          return label != null
              ? DropdownMenuEntry(value: e, label: label)
              : null;
        })
        .whereNotNull()
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _handleInitialValue();
  }

  @override
  void didUpdateWidget(LanguageCodeWidget oldWidget) {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dropdownMenuEntries = _mapItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        SingleSelectDropdown(
          items: _dropdownMenuEntries,
          value: _selectedValue,
          onChanged: _handleValueChanged,
          enabled: widget.isEditMode,
        ),
      ],
    );
  }

  void _handleInitialValue() {
    _selectedValue =
        widget.property.value ?? widget.property.schema.defaultValue;
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

  String? _getLocalizedLanguageName(String languageCode) {
    return LocaleNames.of(context)?.nameOf(languageCode);
  }
}
