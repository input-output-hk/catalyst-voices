import 'package:catalyst_voices/widgets/document_builder/agreement_confirmation_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/document_token_value_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/multiline_text_entry_markdown_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_dropdown_selection_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_grouped_tag_selector_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_line_https_url_widget.dart.dart';
import 'package:catalyst_voices/widgets/document_builder/yes_no_choice_widget.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// Displays a [DocumentSection] as list tile in edit / view mode.
class DocumentBuilderSectionTile extends StatefulWidget {
  /// A section of the document that groups [DocumentProperty].
  final DocumentSection section;

  /// A callback that should be called with a list of [DocumentChange]
  /// when the user wants to save the changes.
  ///
  /// Sections should collect changes from underlying
  /// property builder, show "Save" button and only call
  /// this callback when user wants to save the whole section.
  /// (Usually single property)
  final ValueChanged<List<DocumentChange>> onChanged;

  const DocumentBuilderSectionTile({
    required super.key,
    required this.section,
    required this.onChanged,
  });

  @override
  State<DocumentBuilderSectionTile> createState() {
    return _DocumentBuilderSectionTileState();
  }
}

class _DocumentBuilderSectionTileState
    extends State<DocumentBuilderSectionTile> {
  late DocumentSection _editedSection;
  late DocumentSectionBuilder _builder;

  final _pendingChanges = <DocumentChange>[];

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();

    _editedSection = widget.section;
    _builder = _editedSection.toBuilder();
  }

  @override
  void didUpdateWidget(DocumentBuilderSectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.section != widget.section) {
      _editedSection = widget.section;
      _builder = _editedSection.toBuilder();
      _pendingChanges.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _editedSection.schema.title ?? '';

    return SelectableTile(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              title: title,
              isEditMode: _isEditMode,
              onToggleEditMode: _toggleEditMode,
            ),
            for (final property in widget.section.properties) ...[
              const SizedBox(height: 8),
              _PropertyBuilder(
                key: ValueKey(property.schema.nodeId),
                property: property,
                isEditMode: _isEditMode,
                onChanged: _handlePropertyChange,
              ),
            ],
            if (_isEditMode) ...[
              const SizedBox(height: 12),
              _Footer(
                isValid: _editedSection.isValid,
                onSave: _saveChanges,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    widget.onChanged(List.of(_pendingChanges));

    // ignore: unnecessary_lambdas
    setState(() {
      _pendingChanges.clear();
      _isEditMode = false;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _pendingChanges.clear();
        _editedSection = widget.section;
        _builder = _editedSection.toBuilder();
      }
    });
  }

  void _handlePropertyChange(DocumentChange change) {
    setState(() {
      _builder.addChange(change);
      _editedSection = _builder.build();
      _pendingChanges.add(change);
    });
  }
}

class _Header extends StatelessWidget {
  final String? title;
  final bool isEditMode;
  final VoidCallback? onToggleEditMode;

  const _Header({
    this.title,
    this.isEditMode = false,
    this.onToggleEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 16),
        VoicesTextButton(
          onTap: onToggleEditMode,
          child: Text(
            isEditMode
                ? context.l10n.cancelButtonText
                : context.l10n.editButtonText,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isValid;
  final VoidCallback onSave;

  const _Footer({
    required this.isValid,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: VoicesFilledButton(
        onTap: isValid ? onSave : null,
        child: Text(context.l10n.saveButtonText.toUpperCase()),
      ),
    );
  }
}

class _PropertyBuilder extends StatelessWidget {
  final DocumentProperty property;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const _PropertyBuilder({
    required super.key,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final definition = property.schema.definition;

    switch (definition) {
      case SegmentDefinition():
      case SectionDefinition():
        throw UnsupportedError(
          '${property.schema.definition} unsupported '
          'by $DocumentBuilderSectionTile',
        );
      case SingleLineTextEntryDefinition():
      case MultiLineTextEntryDefinition():
      case MultiSelectDefinition():
      case SingleLineTextEntryListDefinition():
      case MultiLineTextEntryListMarkdownDefinition():
      case SingleLineHttpsURLEntryListDefinition():
      case NestedQuestionsListDefinition():
      case NestedQuestionsDefinition():
      case TagGroupDefinition():
      case TagSelectionDefinition():
      case DurationInMonthsDefinition():
      case SPDXLicenceOrUrlDefinition():
      case LanguageCodeDefinition():
        throw UnimplementedError('${definition.type} not implemented');
      case SingleLineHttpsURLEntryDefinition():
        final castProperty = definition.castProperty(property);
        return SingleLineHttpsUrlWidget(
          property: castProperty,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case SingleGroupedTagSelectorDefinition():
        final castProperty = definition.castProperty(property);
        return SingleGroupedTagSelectorWidget(
          id: castProperty.schema.nodeId,
          selection: castProperty.value ?? const GroupedTagsSelection(),
          groupedTags: definition.groupedTags(castProperty.schema),
          isEditMode: isEditMode,
          onChanged: onChanged,
          isRequired: castProperty.schema.isRequired,
        );
      case DropDownSingleSelectDefinition():
        final castProperty = definition.castProperty(property);
        return SingleDropdownSelectionWidget(
          value: castProperty.value ?? castProperty.schema.defaultValue ?? '',
          items: castProperty.schema.enumValues ?? [],
          definition: definition,
          nodeId: castProperty.schema.nodeId,
          title: castProperty.schema.title ?? '',
          isEditMode: isEditMode,
          isRequired: castProperty.schema.isRequired,
          onChanged: onChanged,
        );
      case AgreementConfirmationDefinition():
        final castProperty = definition.castProperty(property);
        return AgreementConfirmationWidget(
          value: castProperty.value,
          definition: definition,
          nodeId: castProperty.schema.nodeId,
          description: castProperty.schema.description ?? '',
          title: castProperty.schema.title ?? '',
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case TokenValueCardanoADADefinition():
        return DocumentTokenValueWidget(
          property: definition.castProperty(property),
          currency: const Currency.ada(),
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case YesNoChoiceDefinition():
        final castProperty = definition.castProperty(property);
        return YesNoChoiceWidget(
          property: castProperty,
          onChanged: onChanged,
          isEditMode: isEditMode,
          isRequired: castProperty.schema.isRequired,
        );
      case MultiLineTextEntryMarkdownDefinition():
        final castProperty = definition.castProperty(property);
        return MultilineTextEntryMarkdownWidget(
          property: castProperty,
          onChanged: onChanged,
          isEditMode: isEditMode,
          isRequired: castProperty.schema.isRequired,
        );
    }
  }
}
