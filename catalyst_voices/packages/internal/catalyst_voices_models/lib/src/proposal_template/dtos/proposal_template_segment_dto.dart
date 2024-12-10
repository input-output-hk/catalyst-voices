import 'package:catalyst_voices_models/src/proposal_template/dtos/proposal_template_dto.dart';
import 'package:catalyst_voices_models/src/proposal_template/dtos/proposal_template_topic_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_template_segment_dto.g.dart';

@JsonSerializable()
class ProposalTemplateSegmentDTO extends Equatable {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
  final String title;
  final String description;
  final List<ProposalTemplateTopicDto> properties;
  final List<String> required;
  @JsonKey(name: 'x-order')
  final List<String> order;

  const ProposalTemplateSegmentDTO({
    required this.ref,
    required this.id,
    this.title = '',
    this.description = '',
    required this.properties,
    this.required = const <String>[],
    this.order = const <String>[],
  });

  factory ProposalTemplateSegmentDTO.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['properties'] = MapUtils.convertMapToListWithIds(segmentsMap);

    return _$ProposalTemplateSegmentDTOFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProposalTemplateSegmentDTOToJson(this);

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
}
