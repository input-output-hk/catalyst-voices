import 'package:catalyst_voices_models/src/proposal_template/dtos/proposal_template_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_template_element_dto.g.dart';

@JsonSerializable()
class ProposalTemplateElementDto extends Equatable {
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

  const ProposalTemplateElementDto({
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

  factory ProposalTemplateElementDto.fromJson(Map<String, dynamic> json) {
    final segmentsMap = json['properties'] as Map<String, dynamic>;
    json['properties'] = MapUtils.convertMapToListWithIds(segmentsMap);

    return _$ProposalTemplateElementDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProposalTemplateElementDtoToJson(this);

  @override
  List<Object?> get props => [];
}
