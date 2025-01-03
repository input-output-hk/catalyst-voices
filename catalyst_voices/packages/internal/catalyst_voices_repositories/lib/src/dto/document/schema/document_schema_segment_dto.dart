import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_section_dto.dart';
import 'package:catalyst_voices_repositories/src/utils/document_schema_dto_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_schema_segment_dto.g.dart';

@JsonSerializable()
final class DocumentSchemaSegmentDto {
  @JsonKey(includeToJson: false)
  final String id;
  @JsonKey(name: r'$ref')
  final String ref;
  final String title;
  final String? description;
  @JsonKey(name: 'properties')
  @DocumentSchemaSectionsDtoConverter()
  final List<DocumentSchemaSectionDto> sections;
  final List<String>? required;
  @JsonKey(name: 'x-order')
  final List<String>? order;

  const DocumentSchemaSegmentDto({
    required this.id,
    required this.ref,
    required this.title,
    this.description,
    required this.sections,
    this.required,
    this.order,
  });

  factory DocumentSchemaSegmentDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentSchemaSegmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentSchemaSegmentDtoToJson(this);

  DocumentSchemaSegment toModel(
    List<BaseDocumentDefinition> definitions, {
    required DocumentNodeId parentNodeId,
  }) {
    final nodeId = parentNodeId.child(id);
    final order = this.order ?? const [];
    final required = this.required ?? const [];

    final mappedSections = sections
        .where((section) => section.ref.contains('section'))
        .map(
          (e) => e.toModel(
            definitions,
            parentNodeId: nodeId,
            isRequired: required.contains(e.id),
          ),
        )
        .toList();

    return DocumentSchemaSegment(
      definition: definitions.getDefinition(ref),
      nodeId: nodeId,
      id: id,
      title: title,
      description: description,
      sections: mappedSections,
      order: order.map(nodeId.child).toList(),
    );
  }
}
