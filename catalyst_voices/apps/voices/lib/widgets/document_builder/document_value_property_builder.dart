import 'package:catalyst_voices/widgets/document_builder/value/document_builder_value_widget.dart';
import 'package:catalyst_voices/widgets/document_builder/value/double_value_widget.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';
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
        return AgreementConfirmationWidget(
          property: schema.castProperty(property),
          schema: schema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentTokenValueCardanoAdaSchema():
        return DocumentTokenValueWidget(
          property: schema.castProperty(property),
          schema: schema,
          currency: schema.format?.currency ?? const Currency.fallback(),
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
      case DocumentGenericBooleanSchema():
        return _FallbackDebugSchemaWidget(
          schema: schema,
          fallback: YesNoChoiceWidget(
            property: schema.castProperty(property),
            schema: schema,
            onChanged: onChanged,
            isEditMode: isEditMode,
          ),
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
        final castSchema = schema as DocumentStringSchema;
        return SimpleTextEntryWidget(
          property: castSchema.castProperty(property),
          schema: castSchema,
          isEditMode: isEditMode,
          onChanged: onChanged,
        );
      case DocumentGenericStringSchema():
        return _FallbackDebugSchemaWidget(
          schema: schema,
          fallback: SimpleTextEntryWidget(
            property: schema.castProperty(property),
            schema: schema,
            isEditMode: isEditMode,
            onChanged: onChanged,
          ),
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
        return _FallbackDebugSchemaWidget(
          schema: schema,
          fallback: IntegerValueWidget(
            property: schema.castProperty(property),
            schema: schema,
            isEditMode: isEditMode,
            onChanged: onChanged,
          ),
        );
      case DocumentGenericNumberSchema():
        return _FallbackDebugSchemaWidget(
          schema: schema,
          fallback: NumberValueWidget(
            property: schema.castProperty(property),
            schema: schema,
            isEditMode: isEditMode,
            onChanged: onChanged,
          ),
        );
      case DocumentTagGroupSchema():
      case DocumentTagSelectionSchema():
        // DocumentTagGroupSchema and DocumentTagSelectionSchema should
        // be handled by their parent (DocumentSingleGroupedTagSelectorSchema)
        // so the code here should never be executed
        return _UnimplementedSchemaWidget(schema: schema);
    }
  }
}

class _FallbackDebugSchemaWidget extends StatelessWidget {
  final DocumentValueSchema schema;
  final Widget fallback;

  const _FallbackDebugSchemaWidget({
    required this.schema,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // Since we couldn't match the definition lets display this as an error in debug.
      return _UnimplementedSchemaWidget(
        schema: schema,
        fallback: fallback,
      );
    } else {
      // But fallback to a reasonable value in release.
      return fallback;
    }
  }
}

class _UnimplementedSchemaWidget extends StatelessWidget {
  final DocumentPropertySchema schema;
  final Widget? fallback;

  const _UnimplementedSchemaWidget({
    required this.schema,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            'Unimplemented ${schema.runtimeType}: ${schema.nodeId}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          if (fallback case final fallback?) ...[
            const Text(
              'Fallback widget (when not in debug mode): ',
              style: TextStyle(color: Colors.white),
            ),
            fallback,
          ],
        ],
      ),
    );
  }
}
