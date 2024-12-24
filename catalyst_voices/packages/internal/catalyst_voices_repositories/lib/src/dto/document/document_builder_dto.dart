import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_builder_dto.g.dart';

@JsonSerializable()
class DocumentBuilderDto extends Equatable {
  @JsonKey(name: r'$schema')
  final String schema;

  @JsonKey(fromJson: _fromJsonSegments, toJson: _toJsonSegments)
  final List<DocumentBuilderSegmentDto> segments;

  const DocumentBuilderDto({
    required this.schema,
    required this.segments,
  });

  factory DocumentBuilderDto.fromJson(Map<String, dynamic> json) {
    json['segments'] = Map<String, dynamic>.from(json)..remove(r'$schema');
    return _$DocumentBuilderDtoFromJson(json);
  }

  factory DocumentBuilderDto.fromModel(DocumentBuilder model) {
    return DocumentBuilderDto(
      schema: model.schema,
      segments:
          model.segments.map(DocumentBuilderSegmentDto.fromModel).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      r'$schema': schema,
      for (final segment in segments) ...segment.toJson(),
    };
  }

  DocumentBuilder toModel() {
    return DocumentBuilder(
      schema: schema,
      segments: segments.map((e) => e.toModel()).toList(),
    );
  }

  static Map<String, dynamic> _toJsonSegments(
    List<DocumentBuilderSegmentDto> segments,
  ) {
    return {
      for (final segment in segments) segment.id: segment.toJson(),
    };
  }

  static List<DocumentBuilderSegmentDto> _fromJsonSegments(
    Map<String, dynamic> json,
  ) {
    final listOfSegments = json.convertMapToListWithIds();
    return listOfSegments.map(DocumentBuilderSegmentDto.fromJson).toList();
  }

  @override
  List<Object?> get props => [schema, segments];
}

@JsonSerializable()
class DocumentBuilderSegmentDto extends Equatable {
  final String id;

  @JsonKey(fromJson: _fromJsonSections, toJson: _toJsonSections)
  final List<DocumentBuilderSectionDto> sections;

  const DocumentBuilderSegmentDto({
    required this.id,
    required this.sections,
  });

  factory DocumentBuilderSegmentDto.fromJson(Map<String, dynamic> json) {
    json['sections'] = Map<String, dynamic>.from(json)..remove('id');
    return _$DocumentBuilderSegmentDtoFromJson(json);
  }

  factory DocumentBuilderSegmentDto.fromModel(DocumentBuilderSegment model) {
    return DocumentBuilderSegmentDto(
      id: model.id,
      sections:
          model.sections.map(DocumentBuilderSectionDto.fromModel).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        for (final section in sections) ...section.toJson(),
      },
    };
  }

  DocumentBuilderSegment toModel() {
    final nodeId = DocumentNodeId.root.child(id);

    return DocumentBuilderSegment(
      id: id,
      nodeId: nodeId,
      sections: sections.map((e) => e.toModel(parentNodeId: nodeId)).toList(),
    );
  }

  static Map<String, dynamic> _toJsonSections(
    List<DocumentBuilderSectionDto> sections,
  ) {
    return {
      for (final section in sections) section.id: section.toJson(),
    };
  }

  static List<DocumentBuilderSectionDto> _fromJsonSections(
    Map<String, dynamic> json,
  ) {
    final listOfSections = json.convertMapToListWithIds();
    return listOfSections.map(DocumentBuilderSectionDto.fromJson).toList();
  }

  @override
  List<Object?> get props => [id, sections];
}

@JsonSerializable()
class DocumentBuilderSectionDto extends Equatable {
  final String id;

  @JsonKey(fromJson: _fromJsonElements, toJson: _toJsonElements)
  final List<DocumentBuilderElementDto> elements;

  const DocumentBuilderSectionDto({
    required this.id,
    required this.elements,
  });

  factory DocumentBuilderSectionDto.fromJson(Map<String, dynamic> json) {
    json['elements'] = Map<String, dynamic>.from(json)..remove('id');
    return _$DocumentBuilderSectionDtoFromJson(json);
  }

  factory DocumentBuilderSectionDto.fromModel(DocumentBuilderSection model) {
    return DocumentBuilderSectionDto(
      id: model.id,
      elements:
          model.elements.map(DocumentBuilderElementDto.fromModel).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        for (final element in elements) ...element.toJson(),
      },
    };
  }

  DocumentBuilderSection toModel({required DocumentNodeId parentNodeId}) {
    final nodeId = parentNodeId.child(id);
    return DocumentBuilderSection(
      id: id,
      nodeId: nodeId,
      elements: elements.map((e) => e.toModel(parentNodeId: nodeId)).toList(),
    );
  }

  static Map<String, dynamic> _toJsonElements(
    List<DocumentBuilderElementDto> elements,
  ) {
    return {
      for (final element in elements) element.id: element.value,
    };
  }

  static List<DocumentBuilderElementDto> _fromJsonElements(
    Map<String, dynamic> json,
  ) {
    final elements = json.convertMapToListWithIdsAndValues();
    return elements.map(DocumentBuilderElementDto.fromJson).toList();
  }

  @override
  List<Object?> get props => [id, elements];
}

@JsonSerializable()
class DocumentBuilderElementDto extends Equatable {
  final String id;
  final dynamic value;

  const DocumentBuilderElementDto({
    required this.id,
    required this.value,
  });

  factory DocumentBuilderElementDto.fromJson(Map<String, dynamic> json) {
    return _$DocumentBuilderElementDtoFromJson(json);
  }

  factory DocumentBuilderElementDto.fromModel(DocumentBuilderElement model) {
    return DocumentBuilderElementDto(
      id: model.id,
      value: model.value,
    );
  }

  Map<String, dynamic> toJson() => {
        id: value,
      };

  DocumentBuilderElement toModel({required DocumentNodeId parentNodeId}) {
    return DocumentBuilderElement(
      id: id,
      nodeId: parentNodeId.child(id),
      value: value,
    );
  }

  @override
  List<Object?> get props => [id, value];
}
