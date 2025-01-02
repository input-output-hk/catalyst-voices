import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_definitions_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_segment_dto.dart';
import 'package:catalyst_voices_repositories/src/utils/document_schema_dto_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_dto.g.dart';

@JsonSerializable()
final class DocumentSchemaDto {
  @JsonKey(name: r'$schema')
  final String schema;
  @JsonKey(name: r'$id')
  final String id;
  final String title;
  final String description;
  final DocumentDefinitionsDto definitions;
  final String type;
  final bool additionalProperties;
  @JsonKey(name: 'properties')
  @DocumentSchemaSegmentsDtoConverter()
  final List<DocumentSchemaSegmentDto> segments;
  @JsonKey(name: 'x-order')
  final List<String>? order;
  @JsonKey(includeToJson: false)
  final String propertiesSchema;

  const DocumentSchemaDto({
    required this.schema,
    required this.id,
    required this.title,
    required this.description,
    required this.definitions,
    this.type = 'object',
    this.additionalProperties = false,
    required this.segments,
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
    final order = this.order ?? const [];

    final mappedSegments = segments
        .where((e) => e.ref.contains('segment'))
        .map(
          (e) => e.toModel(
            definitions.models,
            parentNodeId: DocumentNodeId.root,
          ),
        )
        .toList();

    return DocumentSchema(
      schema: schema,
      title: title,
      description: description,
      segments: mappedSegments,
      order: order.map(nodeId.child).toList(),
      propertiesSchema: propertiesSchema,
    );
  }
}
