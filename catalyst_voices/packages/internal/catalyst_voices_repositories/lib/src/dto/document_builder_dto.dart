import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_builder_dto.g.dart';

@JsonSerializable()
class DocumentBuilderDto {
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
    final segments = <String, dynamic>{}..addAll({r'$schema': schema});
    for (final segment in this.segments) {
      segments.addAll(segment.toJson());
    }
    return segments;
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
    final map = <String, dynamic>{};
    for (final segment in segments) {
      map[segment.id] = segment.toJson();
    }
    return map;
  }

  static List<DocumentBuilderSegmentDto> _fromJsonSegments(
    Map<String, dynamic> json,
  ) {
    final listOfSegments = json.convertMapToListWithIds();
    return listOfSegments.map(DocumentBuilderSegmentDto.fromJson).toList();
  }
}

@JsonSerializable()
class DocumentBuilderSegmentDto {
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
    final sections = <String, dynamic>{};
    for (final section in this.sections) {
      sections.addAll(section.toJson());
    }
    return {
      id: sections,
    };
  }

  DocumentBuilderSegment toModel() {
    return DocumentBuilderSegment(
      id: id,
      sections: sections.map((e) => e.toModel()).toList(),
    );
  }

  static Map<String, dynamic> _toJsonSections(
    List<DocumentBuilderSectionDto> sections,
  ) {
    final map = <String, dynamic>{};
    for (final section in sections) {
      map[section.id] = section.toJson();
    }
    return map;
  }

  static List<DocumentBuilderSectionDto> _fromJsonSections(
    Map<String, dynamic> json,
  ) {
    final listOfSections = json.convertMapToListWithIds();
    return listOfSections.map(DocumentBuilderSectionDto.fromJson).toList();
  }
}

@JsonSerializable()
class DocumentBuilderSectionDto {
  final String id;
  @JsonKey(fromJson: _fromJsonElements, toJson: _toJsonElements)
  final List<DocumentBuilderElementDto> elements;

  DocumentBuilderSectionDto({
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
    final map = <String, dynamic>{};
    for (final element in elements) {
      map.addAll(element.toJson());
    }
    return {
      id: map,
    };
  }

  DocumentBuilderSection toModel() {
    return DocumentBuilderSection(
      id: id,
      elements: elements.map((e) => e.toModel()).toList(),
    );
  }

  static Map<String, dynamic> _toJsonElements(
    List<DocumentBuilderElementDto> elements,
  ) {
    final map = <String, dynamic>{};
    for (final element in elements) {
      map[element.id] = element.value;
    }
    return map;
  }

  static List<DocumentBuilderElementDto> _fromJsonElements(
    Map<String, dynamic> json,
  ) {
    final listOfElements = json.convertMapToListWithIdsAndValues();
    return listOfElements.map(DocumentBuilderElementDto.fromJson).toList();
  }
}

@JsonSerializable()
class DocumentBuilderElementDto {
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

  DocumentBuilderElement toModel() {
    return DocumentBuilderElement(
      id: id,
      value: value,
    );
  }
}
