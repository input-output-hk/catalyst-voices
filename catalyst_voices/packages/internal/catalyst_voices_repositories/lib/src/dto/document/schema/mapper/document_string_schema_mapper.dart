import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

enum _DocumentStringDefinition {
  singleLineTextEntry('singleLineTextEntry'),
  singleLineHttpsUrlEntry('singleLineHttpsURLEntry'),
  multiLineTextEntry('multiLineTextEntry'),
  multiLineTextEntryMarkdown('multiLineTextEntryMarkdown'),
  dropDownSingleSelect('dropDownSingleSelect'),
  tagGroup('tagGroup'),
  tagSelection('tagSelection'),
  spdxLicenseOrUrl('spdxLicenseOrURL'),
  languageCode('languageCode'),
  unknown('unknown');

  final String def;

  const _DocumentStringDefinition(this.def);

  factory _DocumentStringDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.toLowerCase() == def?.toLowerCase()) {
        return value;
      }
    }

    return _DocumentStringDefinition.unknown;
  }
}

final class DocumentStringSchemaMapper {
  static DocumentStringSchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentPropertySchemaDto schema,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final title = schema.title ?? '';
    final description = schema.description;
    final defaultValue = schema.defaultValue as String?;
    final enumValues = schema.enumValues?.cast<String>();
    final strLengthRange =
        Range.optionalRangeOf(min: schema.minLength, max: schema.maxLength);
    final definition = _DocumentStringDefinition.fromDef(schema.definition());

    switch (definition) {
      case _DocumentStringDefinition.singleLineTextEntry:
        return DocumentSingleLineTextEntrySchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.singleLineHttpsUrlEntry:
        return DocumentSingleLineHttpsUrlEntrySchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.multiLineTextEntry:
        return DocumentMultiLineTextEntrySchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.multiLineTextEntryMarkdown:
        return DocumentMultiLineTextEntryMarkdownSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.dropDownSingleSelect:
        return DocumentDropDownSingleSelectSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.tagGroup:
        return DocumentTagGroupSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.tagSelection:
        return DocumentTagSelectionSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.spdxLicenseOrUrl:
        return DocumentSpdxLicenseOrUrlSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.languageCode:
        return DocumentLanguageCodeSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
      case _DocumentStringDefinition.unknown:
        return DocumentGenericStringSchema(
          nodeId: nodeId,
          title: title,
          description: schema.description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
        );
    }
  }
}
