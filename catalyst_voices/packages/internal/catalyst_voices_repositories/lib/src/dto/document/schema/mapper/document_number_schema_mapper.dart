import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

enum _DocumentNumberDefinition {
  unknown('unknown');

  final String def;

  const _DocumentNumberDefinition(this.def);

  factory _DocumentNumberDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.toLowerCase() == def?.toLowerCase()) {
        return value;
      }
    }

    return _DocumentNumberDefinition.unknown;
  }
}

final class DocumentNumberSchemaMapper {
  static DocumentNumberSchema toModel({
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
    final defaultValue = schema.defaultValue as double?;
    final constValue = schema.constValue as double?;
    final enumValues = schema.enumValues?.cast<double>();
    final numRange = Range.optionalRangeOf(
      min: schema.minimum?.toDouble(),
      max: schema.maximum?.toDouble(),
    );
    final definition = _DocumentNumberDefinition.fromDef(schema.definition());

    switch (definition) {
      case _DocumentNumberDefinition.unknown:
        return DocumentGenericNumberSchema(
          nodeId: nodeId,
          title: title,
          format: format,
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
