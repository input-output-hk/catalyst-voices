import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class DocumentIntegerSchemaMapper {
  static DocumentIntegerSchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentPropertySchemaDto schema,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final format = DocumentPropertyFormat.fromString(schema.format ?? '');
    final title = schema.title ?? '';
    final description = schema.description;
    final descriptionMarkdown =
        description != null ? MarkdownData(description) : null;
    final placeholder = schema.placeholder;
    final guidance = schema.guidance;
    final guidanceMarkdown = guidance != null ? MarkdownData(guidance) : null;
    final isSubsection = schema.subsection ?? false;
    final defaultValue = schema.defaultValue as int?;
    final constValue = schema.constValue as int?;
    final enumValues = schema.enumValues?.cast<int>();
    final numRange =
        NumRange.optionalRangeOf(min: schema.minimum, max: schema.maximum);
    final definition = _DocumentIntegerDefinition.fromDef(schema.definition());

    switch (definition) {
      case _DocumentIntegerDefinition.tokenValueCardanoAda:
        return DocumentTokenValueCardanoAdaSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          numRange: numRange,
        );
      case _DocumentIntegerDefinition.durationInMonths:
        return DocumentDurationInMonthsSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          numRange: numRange,
        );
      case _DocumentIntegerDefinition.unknown:
        return DocumentGenericIntegerSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidanceMarkdown,
          isSubsection: isSubsection,
          isRequired: isRequired,
          defaultValue: defaultValue,
          constValue: constValue,
          enumValues: enumValues,
          numRange: numRange,
        );
    }
  }
}

enum _DocumentIntegerDefinition {
  tokenValueCardanoAda('tokenValueCardanoADA'),
  durationInMonths('durationInMonths'),
  unknown('unknown');

  final String def;

  const _DocumentIntegerDefinition(this.def);

  factory _DocumentIntegerDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.equalsIgnoreCase(def)) {
        return value;
      }
    }

    return _DocumentIntegerDefinition.unknown;
  }
}
