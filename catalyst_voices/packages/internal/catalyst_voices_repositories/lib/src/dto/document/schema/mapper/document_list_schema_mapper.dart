import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

enum _DocumentArrayDefinition {
  multiSelect('multiSelect'),
  singleLineTextEntryList('singleLineTextEntryList'),
  multiLineTextEntryListMarkdown('multiLineTextEntryListMarkdown'),
  singleLineHttpsURLEntryList('singleLineHttpsURLEntryList'),
  nestedQuestionsList('nestedQuestionsList'),
  unknown('unknown');

  final String def;

  const _DocumentArrayDefinition(this.def);

  factory _DocumentArrayDefinition.fromDef(String? def) {
    for (final value in values) {
      if (value.def.toLowerCase() == def?.toLowerCase()) {
        return value;
      }
    }

    return _DocumentArrayDefinition.unknown;
  }
}

final class DocumentListSchemaMapper {
  static DocumentListSchema toModel({
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
    final itemsSchema = schema.items!.toModel(
      definitions: definitions,
      nodeId: nodeId,
      isRequired: isRequired,
    );
    final itemsRange = Range.optionalRangeOf(
      min: schema.minItems,
      max: schema.maxItems,
    );
    final definition = _DocumentArrayDefinition.fromDef(schema.definition());

    switch (definition) {
      case _DocumentArrayDefinition.multiSelect:
        return DocumentMultiSelectSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidance,
          isRequired: isRequired,
          itemsSchema: itemsSchema,
          itemsRange: itemsRange,
        );
      case _DocumentArrayDefinition.singleLineTextEntryList:
        return DocumentSingleLineTextEntryListSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidance,
          isRequired: isRequired,
          itemsSchema: itemsSchema,
          itemsRange: itemsRange,
        );
      case _DocumentArrayDefinition.multiLineTextEntryListMarkdown:
        return DocumentMultiLineTextEntryListMarkdownSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidance,
          isRequired: isRequired,
          itemsSchema: itemsSchema,
          itemsRange: itemsRange,
        );
      case _DocumentArrayDefinition.singleLineHttpsURLEntryList:
        return DocumentSingleLineHttpsUrlEntryListSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidance,
          isRequired: isRequired,
          itemsSchema: itemsSchema,
          itemsRange: itemsRange,
        );
      case _DocumentArrayDefinition.nestedQuestionsList:
        return DocumentNestedQuestionsListSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidance,
          isRequired: isRequired,
          itemsSchema: itemsSchema,
          itemsRange: itemsRange,
        );
      case _DocumentArrayDefinition.unknown:
        return DocumentGenericListSchema(
          nodeId: nodeId,
          format: format,
          title: title,
          description: descriptionMarkdown,
          placeholder: placeholder,
          guidance: guidance,
          isRequired: isRequired,
          itemsSchema: itemsSchema,
          itemsRange: itemsRange,
        );
    }
  }
}
