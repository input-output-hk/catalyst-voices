import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';

enum _DocumentObjectDefinition {
  segment('segment'),
  section('section'),
  nestedQuestions('nestedQuestions'),
  singleGroupedTagSelector('singleGroupedTagSelector'),
  unknown('unknown');

  final String def;

  const _DocumentObjectDefinition(this.def);

  factory _DocumentObjectDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.toLowerCase() == def?.toLowerCase()) {
        return value;
      }
    }

    return _DocumentObjectDefinition.unknown;
  }
}

final class DocumentObjectSchemaMapper {
  static DocumentObjectSchema toModel({
    required DocumentDefinitionsDto definitions,
    required DocumentPropertySchemaDto schema,
    required DocumentNodeId nodeId,
    required bool isRequired,
  }) {
    final format = DocumentPropertyFormat.fromString(schema.format ?? '');
    final title = schema.title ?? '';
    final icon = schema.icon;
    final description = schema.description;
    final descriptionMarkdown =
        description != null ? MarkdownData(description) : null;
    final properties = schema.properties ?? const {};
    final required = schema.required ?? const [];
    final oneOf = schema.oneOf;
    final order = schema.order ?? const [];

    final mappedProperties = properties.entries
        .map(
          (prop) => prop.value.toModel(
            definitions: definitions,
            nodeId: nodeId.child(prop.key),
            isRequired: required.contains(prop.key),
          ),
        )
        .toList();

    final mappedOneOf = oneOf
        ?.map(
          (e) => e.toLogicalGroup(
            definitions: definitions,
            nodeId: nodeId,
            isRequired: isRequired,
          ),
        )
        .toList();
    final mappedOrder = order.map(nodeId.child).toList();

    final definition = _DocumentObjectDefinition.fromDef(schema.definition());
    switch (definition) {
      case _DocumentObjectDefinition.segment:
        return DocumentSegmentSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          isRequired: isRequired,
          properties: mappedProperties,
          oneOf: mappedOneOf,
          order: mappedOrder,
          icon: icon,
        );

      case _DocumentObjectDefinition.section:
        return DocumentSectionSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          isRequired: isRequired,
          properties: mappedProperties,
          oneOf: mappedOneOf,
          order: mappedOrder,
        );
      case _DocumentObjectDefinition.nestedQuestions:
        return DocumentNestedQuestionsSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          isRequired: isRequired,
          properties: mappedProperties,
          oneOf: mappedOneOf,
          order: mappedOrder,
        );
      case _DocumentObjectDefinition.singleGroupedTagSelector:
        return DocumentSingleGroupedTagSelectorSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          isRequired: isRequired,
          properties: mappedProperties,
          oneOf: mappedOneOf,
          order: mappedOrder,
        );
      case _DocumentObjectDefinition.unknown:
        return DocumentGenericObjectSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          isRequired: isRequired,
          properties: mappedProperties,
          oneOf: mappedOneOf,
          order: mappedOrder,
        );
    }
  }
}
