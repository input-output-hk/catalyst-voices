import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class DocumentStringSchemaMapper {
  static DocumentStringSchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentPropertySchemaDto schema,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final format = DocumentPropertyFormat.fromString(schema.format ?? '');
    final contentMediaType =
        DocumentContentMediaType.fromString(schema.contentMediaType ?? '');
    final title = schema.title ?? '';
    final description = schema.description;
    final descriptionMarkdown =
        description != null ? MarkdownData(description) : null;
    final placeholder = schema.placeholder;
    final guidance = schema.guidance;
    final guidanceMarkdown = guidance != null ? MarkdownData(guidance) : null;
    final isSubsection = schema.subsection ?? false;
    final defaultValue = schema.defaultValue as String?;
    final constValue = schema.constValue as String?;
    final enumValues = schema.enumValues?.cast<String>();
    final strLengthRange =
        NumRange.optionalRangeOf(min: schema.minLength, max: schema.maxLength);
    final pattern = schema.pattern;
    final patternRegExp = pattern != null ? RegExp(pattern) : null;
    final definition = _DocumentStringDefinition.fromDef(schema.definition());

    switch (definition) {
      case _DocumentStringDefinition.singleLineTextEntry:
        return DocumentSingleLineTextEntrySchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
      case _DocumentStringDefinition.singleLineHttpsUrlEntry:
        return DocumentSingleLineHttpsUrlEntrySchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
      case _DocumentStringDefinition.multiLineTextEntry:
        return DocumentMultiLineTextEntrySchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
      case _DocumentStringDefinition.multiLineTextEntryMarkdown:
        return DocumentMultiLineTextEntryMarkdownSchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
      case _DocumentStringDefinition.dropDownSingleSelect:
        return DocumentDropDownSingleSelectSchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
      case _DocumentStringDefinition.tagGroup:
        return DocumentTagGroupSchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
      case _DocumentStringDefinition.tagSelection:
        return DocumentTagSelectionSchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );

      case _DocumentStringDefinition.languageCode:
        return DocumentLanguageCodeSchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );

      case _DocumentStringDefinition.radioButtonSelect:
        return DocumentRadioButtonSelect(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
      case _DocumentStringDefinition.unknown:
        return DocumentGenericStringSchema(
          nodeId: nodeId,
          format: format,
          contentMediaType: contentMediaType,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          strLengthRange: strLengthRange,
          pattern: patternRegExp,
        );
    }
  }
}

enum _DocumentStringDefinition {
  singleLineTextEntry('singleLineTextEntry'),
  singleLineHttpsUrlEntry('singleLineHttpsURLEntry'),
  multiLineTextEntry('multiLineTextEntry'),
  multiLineTextEntryMarkdown('multiLineTextEntryMarkdown'),
  dropDownSingleSelect('dropDownSingleSelect'),
  tagGroup('tagGroup'),
  tagSelection('tagSelection'),
  languageCode('languageCode'),
  radioButtonSelect('radioButtonSelect'),
  unknown('unknown');

  final String def;

  const _DocumentStringDefinition(this.def);

  factory _DocumentStringDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.equalsIgnoreCase(def)) {
        return value;
      }
    }

    return _DocumentStringDefinition.unknown;
  }
}
