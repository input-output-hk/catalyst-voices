import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_property_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_section_dto.g.dart';

@JsonSerializable()
final class DocumentSchemaSectionDto {
  @JsonKey(includeToJson: false)
  final String id;
  @JsonKey(name: r'$ref')
  final String ref;
  final String? title;
  final String? description;
  final Map<String, DocumentSchemaPropertyDto> properties;
  final List<String>? required;
  @JsonKey(name: 'x-order')
  final List<String>? order;

  const DocumentSchemaSectionDto({
    required this.id,
    required this.ref,
    this.title,
    this.description,
    required this.properties,
    this.required,
    this.order,
  });

  factory DocumentSchemaSectionDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaSectionDtoToJson(this);

  DocumentSectionSchema toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
    required bool isRequired,
  }) {
    final nodeId = parentNodeId.child(id);
    final order = this.order ?? const [];
    final required = this.required ?? const [];

    final mappedProperties = properties.entries
        .where((prop) => BaseDocumentDefinition.isKnownType(prop.value.ref))
        .map(
          (prop) => prop.value.toModel(
            definitions,
            parentNodeId: nodeId,
            childId: prop.key,
            isRequired: required.contains(prop.key),
          ),
        )
        .toList();

    return DocumentSectionSchema(
      definition: definitions.getDefinition(ref) as SectionDefinition,
      nodeId: nodeId,
      id: id,
      title: title,
      description: description,
      properties: mappedProperties,
      isRequired: isRequired,
      order: order.map(nodeId.child).toList(),
    );
  }
}
