import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

enum _DocumentIntegerDefinition {
  tokenValueCardanoAda('tokenValueCardanoADA'),
  durationInMonths('durationInMonths'),
  unknown('unknown');

  final String def;

  const _DocumentIntegerDefinition(this.def);

  factory _DocumentIntegerDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.toLowerCase() == def?.toLowerCase()) {
        return value;
      }
    }

    return _DocumentIntegerDefinition.unknown;
  }
}

final class DocumentIntegerSchemaMapper {
  static DocumentIntegerSchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentPropertySchemaDto schema,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final title = schema.title ?? '';
    final description = schema.description;
    final defaultValue = schema.defaultValue as int?;
    final enumValues = schema.enumValues?.cast<int>();
    final numRange =
        Range.optionalRangeOf(min: schema.minimum, max: schema.maximum);
    final definition = _DocumentIntegerDefinition.fromDef(schema.definition());

    switch (definition) {
      case _DocumentIntegerDefinition.tokenValueCardanoAda:
        return DocumentTokenValueCardanoAdaSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          numRange: numRange,
        );
      case _DocumentIntegerDefinition.durationInMonths:
        return DocumentDurationInMonthsSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          numRange: numRange,
        );
      case _DocumentIntegerDefinition.unknown:
        return DocumentGenericIntegerSchema(
          nodeId: nodeId,
          title: title,
          description: description,
          isRequired: isRequired,
          defaultValue: defaultValue,
          enumValues: enumValues,
          numRange: numRange,
        );
    }
  }
}
