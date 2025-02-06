import 'package:catalyst_voices/widgets/document_builder/agreement_confirmation_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/document_error_text.dart';
import 'package:catalyst_voices/widgets/document_builder/document_token_value_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/duration_in_months_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/language_code_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/list_length_picker_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/multiline_text_entry_markdown_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/radio_button_selection_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/simple_text_entry_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_dropdown_selection_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_grouped_tag_selector_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/single_line_https_url_widget.dart.dart';
import 'package:catalyst_voices/widgets/document_builder/yes_no_choice_widget.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Displays a [DocumentSectionSchema] as list tile in edit / view mode.
class DocumentBuilderSectionTile extends StatefulWidget {
  /// A section of the document that groups [DocumentValueProperty].
  final DocumentProperty section;

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
  final _formKey = GlobalKey<FormState>();

  late DocumentProperty _editedSection;
  late DocumentPropertyBuilder _builder;

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

    return EditableTile(
      title: title,
      isEditMode: _isEditMode,
      isSaveEnabled: true,
      onChanged: _onEditModeChange,
      child: Form(
        key: _formKey,
        child: _PropertyBuilder(
          key: ValueKey(_editedSection.schema.nodeId),
          property: _editedSection,
          isEditMode: _isEditMode,
          onChanged: _handlePropertyChanges,
        ),
      ),
    );
  }

  void _onEditModeChange(EditableTileChange value) {
    switch (value.source) {
      case EditableTileChangeSource.cancel:
        if (!value.isEditMode) {
          _onCancel();
        } else {
          setState(() {
            _isEditMode = value.isEditMode;
          });
        }

      case EditableTileChangeSource.save:
        if (_formKey.currentState!.validate()) {
          _onSave();
        }
    }
  }

  void _onCancel() {
    setState(() {
      _pendingChanges.clear();
      _editedSection = widget.section;
      _builder = _editedSection.toBuilder();
      _isEditMode = false;
    });
  }

  void _onSave() {
    setState(() {
      widget.onChanged(List.of(_pendingChanges));
      _pendingChanges.clear();
      _isEditMode = false;
    });
  }

  void _handlePropertyChanges(List<DocumentChange> changes) {
    setState(() {
      for (final change in changes) {
        _builder.addChange(change);
      }
      _editedSection = _builder.build();
      _pendingChanges.addAll(changes);
    });
  }
}

class _PropertyBuilder extends StatelessWidget {
  final DocumentProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

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
          property: property,
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
  final DocumentListProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const _PropertyListBuilder({
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final properties = property.properties
        .whereNot((child) => child.schema.isSectionOrSubsection);

    final error =
        LocalizedDocumentValidationResult.from(property.validationResult)
            .message(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...[
          ListLengthPickerWidget(
            key: ValueKey(property.nodeId),
            list: property,
            isEditMode: isEditMode,
            onChanged: onChanged,
          ),
          ...properties.map<Widget>((child) {
            return _PropertyBuilder(
              key: ValueKey(child.nodeId),
              property: child,
              isEditMode: isEditMode,
              onChanged: onChanged,
            );
          }),
        ].separatedBy(const SizedBox(height: 24)),
        if (error != null) ...[
          const SizedBox(height: 4),
          DocumentErrorText(text: error),
        ],
      ],
    );
  }
}

class _PropertyObjectBuilder extends StatelessWidget {
  final DocumentObjectProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

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
          schema: schema,
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );

      case DocumentSegmentSchema():
      case DocumentSectionSchema():
      case DocumentNestedQuestionsSchema():
      case DocumentGenericObjectSchema():
      case DocumentBorderGroupSchema():
        return _GenericPropertyObjectBuilder(
          schema: schema,
          property: property,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
    }
  }
}

class _GenericPropertyObjectBuilder extends StatelessWidget {
  final DocumentObjectSchema schema;
  final DocumentObjectProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const _GenericPropertyObjectBuilder({
    required this.schema,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final schema = property.schema;
    final title = schema.title;
    final properties = property.properties
        .whereNot((child) => child.schema.isSectionOrSubsection);
    final error =
        LocalizedDocumentValidationResult.from(property.validationResult)
            .message(context);

    final showBorder = schema is DocumentBorderGroupSchema;

    return Container(
      width: double.infinity,
      padding: showBorder ? const EdgeInsets.all(16) : null,
      decoration: showBorder
          ? BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty && !schema.isSectionOrSubsection) ...[
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
          ],
          ...properties.map<Widget>((child) {
            return _PropertyBuilder(
              key: ValueKey(child.nodeId),
              property: child,
              isEditMode: isEditMode,
              onChanged: onChanged,
            );
          }).separatedBy(const SizedBox(height: 24)),
          if (error != null) ...[
            if (properties.isNotEmpty) const SizedBox(height: 4),
            DocumentErrorText(text: error),
          ],
        ],
      ),
    );
  }
}

class _PropertyValueBuilder extends StatelessWidget {
  final DocumentValueProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

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
        return SingleDropdownSelectionWidget(
          property: schema.castProperty(property),
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
      case DocumentGenericBooleanSchema():
        final castSchema = schema as DocumentBooleanSchema;
        return YesNoChoiceWidget(
          property: castSchema.castProperty(property),
          schema: castSchema,
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

      case DocumentRadioButtonSelect():
        return RadioButtonSelectWidget(
          property: schema.castProperty(property),
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );

      case DocumentDurationInMonthsSchema():
        return DurationInMonthsWidget(
          property: schema.castProperty(property),
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentLanguageCodeSchema():
        return LanguageCodeWidget(
          property: schema.castProperty(property),
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentGenericIntegerSchema():
      case DocumentGenericNumberSchema():
        return _UnimplementedSchemaWidget(schema: schema);

      case DocumentTagGroupSchema():
      case DocumentTagSelectionSchema():
        // DocumentTagGroupSchema and DocumentTagSelectionSchema should
        // be handled by their parent (DocumentSingleGroupedTagSelectorSchema)
        // so the code here should never be executed
        return _UnimplementedSchemaWidget(schema: schema);
    }
  }
}

class _UnimplementedSchemaWidget extends StatelessWidget {
  final DocumentPropertySchema schema;

  const _UnimplementedSchemaWidget({
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
