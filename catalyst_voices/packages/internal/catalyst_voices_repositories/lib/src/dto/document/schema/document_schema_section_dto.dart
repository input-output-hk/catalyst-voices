import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_property_dto.dart';
import 'package:catalyst_voices_repositories/src/utils/document_schema_dto_converter.dart';
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
  @DocumentSchemaPropertiesDtoConverter()
  final List<DocumentSchemaPropertyDto> properties;
  final List<String>? required;
  @JsonKey(name: 'x-order')
  final List<String>? order;

  // conditional logic
  @JsonKey(name: 'if')
  final DocumentSchemaIfConditionDto? ifs;
  @JsonKey(name: 'then')
  final DocumentSchemaSectionBodyDto? then;
  @JsonKey(name: 'else')
  final DocumentSchemaSectionBodyDto? elses;

  const DocumentSchemaSectionDto({
    required this.id,
    required this.ref,
    this.title,
    this.description,
    required this.properties,
    this.required,
    this.order,
    this.ifs,
    this.then,
    this.elses,
  });

  factory DocumentSchemaSectionDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaSectionDtoToJson(this);

  DocumentSchemaSection toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
    required bool isRequired,
  }) {
    final nodeId = parentNodeId.child(id);
    final order = this.order ?? const [];
    final required = this.required ?? const [];

    final mappedProperties = properties
        .where((property) => BaseDocumentDefinition.isKnownType(property.ref))
        .map(
          (e) => e.toModel(
            definitions,
            parentNodeId: nodeId,
            isRequired: required.contains(e.id),
          ),
        )
        .toList();

    return DocumentSchemaSection(
      definition: definitions.getDefinition(ref),
      nodeId: nodeId,
      id: id,
      title: title ?? '',
      description: description ?? '',
      properties: mappedProperties,
      isRequired: isRequired,
      order: order.map(nodeId.child).toList(),
    );
  }
}

/// Similar to [DocumentSchemaSectionDto] but all fields must be optional.
@JsonSerializable()
final class DocumentSchemaSectionBodyDto {
  @JsonKey(name: r'$ref')
  final String? ref;
  final String? title;
  final String? description;
  @DocumentSchemaPropertiesDtoConverter()
  final List<DocumentSchemaPropertyDto>? properties;
  final List<String>? required;
  @JsonKey(name: 'x-order')
  final List<String>? order;

  // conditional logic
  @JsonKey(name: 'if')
  final DocumentSchemaIfConditionDto? ifs;
  @JsonKey(name: 'then')
  final DocumentSchemaSectionBodyDto? then;
  @JsonKey(name: 'else')
  final DocumentSchemaSectionBodyDto? elses;

  const DocumentSchemaSectionBodyDto({
    this.ref,
    this.title,
    this.description,
    this.properties,
    this.required,
    this.order,
    this.ifs,
    this.then,
    this.elses,
  });

  factory DocumentSchemaSectionBodyDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaSectionBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaSectionBodyDtoToJson(this);
}

@JsonSerializable()
final class DocumentSchemaIfConditionDto {
  @JsonKey(name: 'properties')
  final Map<String, dynamic>? properties;

  const DocumentSchemaIfConditionDto({
    required this.properties,
  });

  factory DocumentSchemaIfConditionDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaIfConditionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaIfConditionDtoToJson(this);
}
