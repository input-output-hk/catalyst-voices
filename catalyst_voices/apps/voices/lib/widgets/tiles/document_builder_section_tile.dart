import 'package:catalyst_voices/widgets/document_builder/agreement_confirmation_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/document_token_value_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/multiline_text_entry_markdown_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/simple_text_entry_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_dropdown_selection_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_grouped_tag_selector_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_line_https_url_widget.dart.dart';
import 'package:catalyst_voices/widgets/document_builder/yes_no_choice_widget.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// Displays a [DocumentSectionSchema] as list tile in edit / view mode.
class DocumentBuilderSectionTile extends StatefulWidget {
  /// A section of the document that groups [DocumentValueProperty].
  final DocumentObjectProperty section;

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
  late DocumentObjectProperty _editedSection;
  late DocumentObjectPropertyBuilder _builder;

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
    final title = _editedSection.schema.title;

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
              const SizedBox(height: 24),
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
  final String title;
  final bool isEditMode;
  final VoidCallback? onToggleEditMode;

  const _Header({
    required this.title,
    this.isEditMode = false,
    this.onToggleEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
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
    final property = this.property;
    switch (property) {
      case DocumentListProperty():
        return _PropertyListBuilder(
          list: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentObjectProperty():
        return _PropertyObjectBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentValueProperty():
        return _PropertyValueBuilder(
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
    }
  }
}

class _PropertyListBuilder extends StatelessWidget {
  final DocumentListProperty list;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const _PropertyListBuilder({
    required this.list,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(dtscalac): build a property list, similar to a section,
    // below is just dummy implementation

    // TODO(dtscalac): there should be a plus button or something similar
    // to add more items into the list

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final property in list.properties)
          _PropertyBuilder(
            key: key,
            property: property,
            isEditMode: isEditMode,
            onChanged: onChanged,
          ),
      ].separatedBy(const SizedBox(height: 24)).toList(),
    );
  }
}

class _PropertyObjectBuilder extends StatelessWidget {
  final DocumentObjectProperty property;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const _PropertyObjectBuilder({
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final schema = property.schema;
    switch (schema) {
      case DocumentSingleGroupedTagSelectorSchema():
        return SingleGroupedTagSelectorWidget(
          id: property.schema.nodeId,
          selection: schema.groupedTagsSelection(property) ??
              const GroupedTagsSelection(),
          groupedTags: schema.groupedTags(),
          isEditMode: isEditMode,
          onChanged: onChanged,
          isRequired: schema.isRequired,
        );

      case DocumentNestedQuestionsSchema():
      case DocumentGenericObjectSchema():
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final property in property.properties)
              _PropertyBuilder(
                key: key,
                property: property,
                isEditMode: isEditMode,
                onChanged: onChanged,
              ),
          ].separatedBy(const SizedBox(height: 24)).toList(),
        );

      case DocumentSegmentSchema():
      case DocumentSectionSchema():
        throw UnsupportedError(
          '${schema.type} not supported on this level.',
        );
    }
  }
}

class _PropertyValueBuilder extends StatelessWidget {
  final DocumentValueProperty property;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const _PropertyValueBuilder({
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final schema = property.schema;
    switch (schema) {
      case DocumentDropDownSingleSelectSchema():
        final castProperty = schema.castProperty(property);
        return SingleDropdownSelectionWidget(
          value: castProperty.value ?? castProperty.schema.defaultValue ?? '',
          items: castProperty.schema.enumValues ?? [],
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentAgreementConfirmationSchema():
        final castProperty = schema.castProperty(property);
        return AgreementConfirmationWidget(
          property: castProperty,
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentTokenValueCardanoAdaSchema():
        return DocumentTokenValueWidget(
          property: schema.castProperty(property),
          schema: schema,
          currency: const Currency.ada(),
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentYesNoChoiceSchema():
        return YesNoChoiceWidget(
          property: schema.castProperty(property),
          schema: schema,
          onChanged: onChanged,
          isEditMode: isEditMode,
        );
      case DocumentSingleLineHttpsUrlEntrySchema():
        return SingleLineHttpsUrlWidget(
          property: schema.castProperty(property),
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentSingleLineTextEntrySchema():
      case DocumentMultiLineTextEntrySchema():
      case DocumentGenericStringSchema():
        final castSchema = schema as DocumentStringSchema;
        return SimpleTextEntryWidget(
          property: castSchema.castProperty(property),
          schema: castSchema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );

      case DocumentMultiLineTextEntryMarkdownSchema():
        return MultilineTextEntryMarkdownWidget(
          property: schema.castProperty(property),
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );

      case DocumentSpdxLicenseOrUrlSchema():
      case DocumentLanguageCodeSchema():
      case DocumentDurationInMonthsSchema():
      case DocumentGenericIntegerSchema():
      case DocumentGenericNumberSchema():
      case DocumentGenericBooleanSchema():
        return _UnimplementedWidget(schema: schema);

      case DocumentTagGroupSchema():
      case DocumentTagSelectionSchema():
        // DocumentTagGroupSchema and DocumentTagSelectionSchema should
        // be handled by their parent (DocumentSingleGroupedTagSelectorSchema)
        // so the code here should never be executed
        return _UnimplementedWidget(schema: schema);
    }
  }
}

// TODO(dtscalac): remove this widget when all document properties
// are implemented
class _UnimplementedWidget extends StatelessWidget {
  final DocumentPropertySchema schema;

  const _UnimplementedWidget({
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Unimplemented ${schema.runtimeType}: ${schema.nodeId}',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
