import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_dto.g.dart';

// TODO(dtscalac): convert from raw property into
// enums/lists as needed by value
// TODO(dtscalac): validate that value is of correct type, ignore if not

/// A data transfer object for the [Document].
/// 
/// Encodable as json but to decode it a [DocumentSchema]
/// is needed which explains how to interpret the data.
@JsonSerializable()
class DocumentDto extends Equatable {
  @JsonKey(name: r'$schema')
  final String schema;

  @JsonKey(fromJson: _fromJsonSegments, toJson: _toJsonSegments)
  final List<DocumentSegmentDto> segments;

  const DocumentDto({
    required this.schema,
    required this.segments,
  });

  factory DocumentDto.fromJson(Map<String, dynamic> json) {
    json['segments'] = Map.of(json)..remove(r'$schema');
    return _$DocumentDtoFromJson(json);
  }

  factory DocumentDto.fromModel(Document model) {
    return DocumentDto(
      schema: model.schema,
      segments: model.segments.map(DocumentSegmentDto.fromModel).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      r'$schema': schema,
      for (final segment in segments) ...segment.toJson(),
    };
  }

  Document toModel(DocumentSchema documentSchema) {
    return Document(
      schema: schema,
      segments: segments.map((e) => e.toModel()).toList(),
    );
  }

  static Map<String, dynamic> _toJsonSegments(
    List<DocumentSegmentDto> segments,
  ) {
    return {
      for (final segment in segments) segment.id: segment.toJson(),
    };
  }

  static List<DocumentSegmentDto> _fromJsonSegments(
    Map<String, dynamic> json,
  ) {
    final listOfSegments = json.convertMapToListWithIds();
    return listOfSegments.map(DocumentSegmentDto.fromJson).toList();
  }

  @override
  List<Object?> get props => [schema, segments];
}

@JsonSerializable()
class DocumentSegmentDto extends Equatable {
  final String id;

  @JsonKey(fromJson: _fromJsonSections, toJson: _toJsonSections)
  final List<DocumentSectionDto> sections;

  const DocumentSegmentDto({
    required this.id,
    required this.sections,
  });

  factory DocumentSegmentDto.fromJson(Map<String, dynamic> json) {
    json['sections'] = Map.of(json)..remove('id');
    return _$DocumentSegmentDtoFromJson(json);
  }

  factory DocumentSegmentDto.fromModel(DocumentSegment model) {
    return DocumentSegmentDto(
      id: model.id,
      sections: model.sections.map(DocumentSectionDto.fromModel).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        for (final section in sections) ...section.toJson(),
      },
    };
  }

  DocumentSegment toModel() {
    final nodeId = DocumentNodeId.root.child(id);

    return DocumentSegment(
      id: id,
      nodeId: nodeId,
      sections: sections.map((e) => e.toModel(parentNodeId: nodeId)).toList(),
    );
  }

  static Map<String, dynamic> _toJsonSections(
    List<DocumentSectionDto> sections,
  ) {
    return {
      for (final section in sections) section.id: section.toJson(),
    };
  }

  static List<DocumentSectionDto> _fromJsonSections(
    Map<String, dynamic> json,
  ) {
    final listOfSections = json.convertMapToListWithIds();
    return listOfSections.map(DocumentSectionDto.fromJson).toList();
  }

  @override
  List<Object?> get props => [id, sections];
}

@JsonSerializable()
class DocumentSectionDto extends Equatable {
  final String id;

  @JsonKey(fromJson: _fromJsonElements, toJson: _toJsonElements)
  final List<DocumentElementDto> elements;

  const DocumentSectionDto({
    required this.id,
    required this.elements,
  });

  factory DocumentSectionDto.fromJson(Map<String, dynamic> json) {
    json['elements'] = Map.of(json)..remove('id');
    return _$DocumentSectionDtoFromJson(json);
  }

  factory DocumentSectionDto.fromModel(DocumentSection model) {
    return DocumentSectionDto(
      id: model.id,
      elements: model.elements.map(DocumentElementDto.fromModel).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        for (final element in elements) ...element.toJson(),
      },
    };
  }

  DocumentSection toModel({required DocumentNodeId parentNodeId}) {
    final nodeId = parentNodeId.child(id);
    return DocumentSection(
      id: id,
      nodeId: nodeId,
      elements: elements.map((e) => e.toModel(parentNodeId: nodeId)).toList(),
    );
  }

  static Map<String, dynamic> _toJsonElements(
    List<DocumentElementDto> elements,
  ) {
    return {
      for (final element in elements) element.id: element.value,
    };
  }

  static List<DocumentElementDto> _fromJsonElements(
    Map<String, dynamic> json,
  ) {
    final elements = json.convertMapToListWithIdsAndValues();
    return elements.map(DocumentElementDto.fromJson).toList();
  }

  @override
  List<Object?> get props => [id, elements];
}

@JsonSerializable()
class DocumentElementDto extends Equatable {
  final String id;
  final dynamic value;

  const DocumentElementDto({
    required this.id,
    required this.value,
  });

  factory DocumentElementDto.fromJson(Map<String, dynamic> json) {
    return _$DocumentElementDtoFromJson(json);
  }

  factory DocumentElementDto.fromModel(DocumentElement model) {
    return DocumentElementDto(
      id: model.id,
      value: model.value,
    );
  }

  Map<String, dynamic> toJson() => {
        id: value,
      };

  DocumentElement toModel({required DocumentNodeId parentNodeId}) {
    return DocumentElement(
      id: id,
      nodeId: parentNodeId.child(id),
      value: value,
    );
  }

  @override
  List<Object?> get props => [id, value];
}
