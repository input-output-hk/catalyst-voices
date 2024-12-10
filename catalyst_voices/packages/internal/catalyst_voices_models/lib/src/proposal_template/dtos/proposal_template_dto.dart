import 'package:catalyst_voices_models/src/proposal_template/dtos/proposal_template_segment_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_template_dto.g.dart';

@JsonSerializable()
class ProposalTemplateDTO extends Equatable {
  @JsonKey(name: r'$schema')
  final String schema;
  final String title;
  final String description;
  final Map<String, dynamic> definitions;
  final String type;
  final bool additionalProperties;
  final List<ProposalTemplateSegmentDTO> properties;
  @JsonKey(name: 'x-order')
  final List<String> order;

  const ProposalTemplateDTO({
    required this.schema,
    required this.title,
    required this.description,
    required this.definitions,
    this.type = 'object',
    this.additionalProperties = false,
    required this.properties,
    required this.order,
  });

  factory ProposalTemplateDTO.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['properties'] = MapUtils.convertMapToListWithIds(segmentsMap);

    return _$ProposalTemplateDTOFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProposalTemplateDTOToJson(this);

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
}

class MapUtils {
  static List<Map<String, dynamic>> convertMapToListWithIds(
    Map<String, dynamic> map,
  ) {
    final list = <Map<String, dynamic>>[];

    for (final entry in map.entries) {
      if (entry.key == r'$schema') continue;
      final value = entry.value as Map<String, dynamic>;
      value['id'] = entry.key;
      list.add(value);
    }

    return list;
  }
}
