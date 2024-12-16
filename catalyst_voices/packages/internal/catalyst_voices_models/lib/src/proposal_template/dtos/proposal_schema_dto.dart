import 'package:catalyst_voices_models/src/proposal_template/dtos/proposal_definitions_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_schema_dto.g.dart';

@JsonSerializable()
class ProposalSchemaDTO extends Equatable {
  @JsonKey(name: r'$schema')
  final String schema;
  final String title;
  final String description;
  final ProposalDefinitionsDTO definitions;
  final String type;
  final bool additionalProperties;
  @JsonKey(toJson: _toJsonProperties)
  final List<ProposalSchemaSegmentDTO> properties;
  @JsonKey(name: 'x-order')
  final List<String> order;

  const ProposalSchemaDTO({
    required this.schema,
    required this.title,
    required this.description,
    required this.definitions,
    this.type = 'object',
    this.additionalProperties = false,
    required this.properties,
    required this.order,
  });

  factory ProposalSchemaDTO.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['properties'] = segmentsMap.convertMapToListWithIds();

    return _$ProposalSchemaDTOFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProposalSchemaDTOToJson(this);

  @override
  List<Object?> get props => [
        schema,
        title,
        description,
        definitions,
        type,
        additionalProperties,
        properties,
        order,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<ProposalSchemaSegmentDTO> properties,
  ) {
    final map = <String, dynamic>{};
    for (final property in properties) {
      map[property.id] = property.toJson();
    }
    return map;
  }
}

@JsonSerializable()
class ProposalSchemaSegmentDTO extends Equatable {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
  final String title;
  final String description;
  @JsonKey(toJson: _toJsonProperties)
  final List<ProposalSectionTopicDto> properties;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;

  const ProposalSchemaSegmentDTO({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.properties,
    this.required = const <String>[],
    this.order = const <String>[],
  });

  factory ProposalSchemaSegmentDTO.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['properties'] = segmentsMap.convertMapToListWithIds();

    return _$ProposalSchemaSegmentDTOFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProposalSchemaSegmentDTOToJson(this);

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        properties,
        required,
        order,
      ];

  static Map<String, dynamic> _toJsonProperties(
    List<ProposalSectionTopicDto> properties,
  ) {
    final map = <String, dynamic>{};
    for (final property in properties) {
      map[property.id] = property.toJson();
    }
    return map;
  }
}

@JsonSerializable()
class ProposalSectionTopicDto extends Equatable {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
  final String title;
  final String description;
  final List<dynamic> properties;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;
  final Map<String, dynamic> dependencies; // Return to this
  @JsonKey(name: 'if')
  final Map<String, dynamic> ifs;
  final Map<String, dynamic> then; // Return to this
  @JsonKey(name: 'open_source')
  final Map<String, dynamic> openSource; // Return to this

  const ProposalSectionTopicDto({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.properties,
    this.required = const <String>[],
    this.order = const <String>[],
    this.dependencies = const <String, dynamic>{},
    this.ifs = const <String, dynamic>{},
    this.then = const <String, dynamic>{},
    this.openSource = const <String, dynamic>{},
  });

  factory ProposalSectionTopicDto.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['properties'] = segmentsMap.convertMapToListWithIds();

    return _$ProposalSectionTopicDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProposalSectionTopicDtoToJson(this);

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        properties,
        required,
        order,
        dependencies,
        ifs,
        then,
      ];
}

@JsonSerializable()
class ProposalSchemaElementDTO extends Equatable {
  @JsonKey(name: r'$ref', includeToJson: false)
  final String ref;
  final String id;
  final String title;
  final String description;
  final String? minLength;
  final String? maxLength;
  @JsonKey(name: 'default')
  final String defaultValue;
  @JsonKey(name: 'x-guidance')
  final String guidance;
  @JsonKey(name: 'enum')
  final List<String> enumValues;
  final int? maxItems;
  final int? minItems;
  final int? minimum;
  final int? maximum;
  final List<String> examples;
  final Map<String, dynamic> items; // TODO(ryszard-shossler): return to this

  const ProposalSchemaElementDTO({
    required this.ref,
    required this.id,
    required this.title,
    required this.description,
    required this.minLength,
    required this.maxLength,
    this.defaultValue = '',
    required this.guidance,
    this.enumValues = const <String>[],
    required this.maxItems,
    required this.minItems,
    required this.minimum,
    required this.maximum,
    this.examples = const <String>[],
    this.items = const <String, dynamic>{},
  });

  factory ProposalSchemaElementDTO.fromJson(Map<String, dynamic> json) =>
      _$ProposalSchemaElementDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProposalSchemaElementDTOToJson(this);

  @override
  List<Object?> get props => [
        ref,
        id,
        title,
        description,
        minLength,
        maxLength,
        defaultValue,
        guidance,
        enumValues,
        maxItems,
        minItems,
        minimum,
        maximum,
        examples,
      ];
}
