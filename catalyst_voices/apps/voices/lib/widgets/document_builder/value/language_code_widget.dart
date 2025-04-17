import 'package:catalyst_voices/widgets/document_builder/common/document_property_builder_title.dart';
import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
  bool get _isRequired => widget.schema.isRequired;
  String get _title => widget.schema.title;
  String? get _value => widget.property.value ?? widget.schema.defaultValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_title.isNotEmpty) ...[
          DocumentPropertyBuilderTitle(
            title: _title,
            isRequired: _isRequired,
          ),
          const SizedBox(height: 8),
        ],
        SingleSelectDropdown(
          items: _buildMenuEntries(),
          value: _value,
          onChanged: _onChanged,
          enabled: widget.isEditMode,
        ),
      ],
    );
  }

  List<DropdownMenuEntry<String>> _buildMenuEntries() {
    return (widget.schema.enumValues ?? [])
        .map((e) {
          final label = _getLocalizedLanguageName(e);
          return label != null
              ? DropdownMenuEntry(value: e, label: label)
              : null;
        })
        .nonNulls
        .toList();
  }

  String? _getLocalizedLanguageName(String languageCode) {
    return LocaleNames.of(context)?.nameOf(languageCode);
  }

  void _onChanged(String? value) {
    final normalizedValue = widget.schema.normalizeValue(value);
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: normalizedValue,
    );
    widget.onChanged([change]);
  }
}
