import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_property_schema_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_dto.g.dart';

@JsonSerializable(includeIfNull: false)
final class DocumentSchemaDto {
  @JsonKey(name: r'$schema')
  final String jsonSchema;
  @JsonKey(name: r'$id')
  final String jsonSchemaId;
  final String title;
  final String description;
  final DocumentDefinitionsDto definitions;
  final String type;
  final bool additionalProperties;
  final Map<String, DocumentPropertySchemaDto> properties;
  final List<String>? required;
  @JsonKey(name: 'x-order')
  final List<String>? order;
  @JsonKey(includeToJson: false)
  final String propertiesSchema;

  const DocumentSchemaDto({
    required this.jsonSchema,
    required this.jsonSchemaId,
    required this.title,
    required this.description,
    required this.definitions,
    this.type = 'object',
    this.additionalProperties = false,
    required this.properties,
    required this.required,
    required this.order,
    required this.propertiesSchema,
  });

  factory DocumentSchemaDto.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['propertiesSchema'] =
        (segmentsMap[r'$schema'] as Map<String, dynamic>)['const'];

    return _$DocumentSchemaDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DocumentSchemaDtoToJson(this);

  DocumentSchema toModel() {
    const nodeId = DocumentNodeId.root;
    final required = this.required ?? const [];
    final order = this.order ?? const [];

    final mappedProperties = properties.entries
        .map(
          (property) => property.value.toModel(
            definitions: definitions,
            nodeId: DocumentNodeId.root.child(property.key),
            isRequired: required.contains(property.key),
          ),
        )
        .toList();

    return DocumentSchema(
      jsonSchema: jsonSchema,
      title: title,
      description: MarkdownData(description),
      properties: mappedProperties,
      order: order.map(nodeId.child).toList(),
      propertiesSchema: propertiesSchema,
    );
  }
}
