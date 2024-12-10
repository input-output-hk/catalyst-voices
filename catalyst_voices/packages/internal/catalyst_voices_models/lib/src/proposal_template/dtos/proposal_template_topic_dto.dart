import 'package:catalyst_voices_models/src/proposal_template/dtos/proposal_template_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_template_topic_dto.g.dart';

@JsonSerializable()
class ProposalTemplateTopicDto extends Equatable {
  @JsonKey(name: r'$ref')
  final String ref;
  final String id;
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

  const ProposalTemplateTopicDto({
    required this.ref,
    required this.id,
    this.description = '',
    required this.properties,
    this.required = const <String>[],
    this.order = const <String>[],
    this.dependencies = const <String, dynamic>{},
    this.ifs = const <String, dynamic>{},
    this.then = const <String, dynamic>{},
    this.openSource = const <String, dynamic>{},
  });

  factory ProposalTemplateTopicDto.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['properties'] = MapUtils.convertMapToListWithIds(segmentsMap);

    return _$ProposalTemplateTopicDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProposalTemplateTopicDtoToJson(this);

  @override
  List<Object?> get props => [
        ref,
        id,
        description,
        properties,
        required,
        order,
        dependencies,
        ifs,
        then,
      ];
}
