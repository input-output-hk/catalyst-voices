import 'package:catalyst_voices/widgets/document_builder/value/document_builder_value_widget.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentValuePropertyBuilder extends StatelessWidget {
  final DocumentValueProperty property;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const DocumentValuePropertyBuilder({
    super.key,
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
