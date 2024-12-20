import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_builder_dto.g.dart';

@JsonSerializable()
class ProposalBuilderDto {
  @JsonKey(name: r'$schema')
  final String schema;
  @JsonKey(fromJson: _fromJsonSegments, toJson: _toJsonSegments)
  final List<ProposalBuilderSegmentDto> segments;
  const ProposalBuilderDto({
    required this.schema,
    required this.segments,
  });

  factory ProposalBuilderDto.fromJson(Map<String, dynamic> json) {
    json['segments'] = Map<String, dynamic>.from(json)..remove(r'$schema');
    return _$ProposalBuilderDtoFromJson(json);
  }

  factory ProposalBuilderDto.fromModel(ProposalBuilder model) {
    return ProposalBuilderDto(
      schema: model.schema,
      segments:
          model.segments.map(ProposalBuilderSegmentDto.fromModel).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final segments = <String, dynamic>{}..addAll({r'$schema': schema});
    for (final segment in this.segments) {
      segments.addAll(segment.toJson());
    }
    return segments;
  }

  ProposalBuilder toModel() {
    return ProposalBuilder(
      schema: schema,
      segments: segments.map((e) => e.toModel()).toList(),
    );
  }

  static Map<String, dynamic> _toJsonSegments(
    List<ProposalBuilderSegmentDto> segments,
  ) {
    final map = <String, dynamic>{};
    for (final segment in segments) {
      map[segment.id] = segment.toJson();
    }
    return map;
  }

  static List<ProposalBuilderSegmentDto> _fromJsonSegments(
    Map<String, dynamic> json,
  ) {
    final listOfSegments = json.convertMapToListWithIds();
    return listOfSegments.map(ProposalBuilderSegmentDto.fromJson).toList();
  }
}

@JsonSerializable()
class ProposalBuilderSegmentDto {
  final String id;
  @JsonKey(fromJson: _fromJsonSections, toJson: _toJsonSections)
  final List<ProposalBuilderSectionDto> sections;

  const ProposalBuilderSegmentDto({
    required this.id,
    required this.sections,
  });

  factory ProposalBuilderSegmentDto.fromJson(Map<String, dynamic> json) {
    json['sections'] = Map<String, dynamic>.from(json)..remove('id');
    return _$ProposalBuilderSegmentDtoFromJson(json);
  }

  factory ProposalBuilderSegmentDto.fromModel(ProposalBuilderSegment model) {
    return ProposalBuilderSegmentDto(
      id: model.id,
      sections:
          model.sections.map(ProposalBuilderSectionDto.fromModel).toList(),
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

  ProposalBuilderSegment toModel() {
    return ProposalBuilderSegment(
      id: id,
      sections: sections.map((e) => e.toModel()).toList(),
    );
  }

  static Map<String, dynamic> _toJsonSections(
    List<ProposalBuilderSectionDto> sections,
  ) {
    final map = <String, dynamic>{};
    for (final section in sections) {
      map[section.id] = section.toJson();
    }
    return map;
  }

  static List<ProposalBuilderSectionDto> _fromJsonSections(
    Map<String, dynamic> json,
  ) {
    final listOfSections = json.convertMapToListWithIds();
    return listOfSections.map(ProposalBuilderSectionDto.fromJson).toList();
  }
}

@JsonSerializable()
class ProposalBuilderSectionDto {
  final String id;
  @JsonKey(fromJson: _fromJsonElements, toJson: _toJsonElements)
  final List<ProposalBuilderElementDto> elements;

  ProposalBuilderSectionDto({
    required this.id,
    required this.elements,
  });

  factory ProposalBuilderSectionDto.fromJson(Map<String, dynamic> json) {
    json['elements'] = Map<String, dynamic>.from(json)..remove('id');
    return _$ProposalBuilderSectionDtoFromJson(json);
  }

  factory ProposalBuilderSectionDto.fromModel(ProposalBuilderSection model) {
    return ProposalBuilderSectionDto(
      id: model.id,
      elements:
          model.elements.map(ProposalBuilderElementDto.fromModel).toList(),
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

  ProposalBuilderSection toModel() {
    return ProposalBuilderSection(
      id: id,
      elements: elements.map((e) => e.toModel()).toList(),
    );
  }

  static Map<String, dynamic> _toJsonElements(
    List<ProposalBuilderElementDto> elements,
  ) {
    final map = <String, dynamic>{};
    for (final element in elements) {
      map[element.id] = element.value;
    }
    return map;
  }

  static List<ProposalBuilderElementDto> _fromJsonElements(
    Map<String, dynamic> json,
  ) {
    final listOfElements = json.convertMapToListWithIdsAndValues();
    return listOfElements.map(ProposalBuilderElementDto.fromJson).toList();
  }
}

@JsonSerializable()
class ProposalBuilderElementDto {
  final String id;
  final dynamic value;

  const ProposalBuilderElementDto({
    required this.id,
    required this.value,
  });

  factory ProposalBuilderElementDto.fromJson(Map<String, dynamic> json) {
    return _$ProposalBuilderElementDtoFromJson(json);
  }

  factory ProposalBuilderElementDto.fromModel(ProposalBuilderElement model) {
    return ProposalBuilderElementDto(
      id: model.id,
      value: model.value,
    );
  }

  Map<String, dynamic> toJson() => {
        id: value,
      };

  ProposalBuilderElement toModel() {
    return ProposalBuilderElement(
      id: id,
      value: value,
    );
  }
}
