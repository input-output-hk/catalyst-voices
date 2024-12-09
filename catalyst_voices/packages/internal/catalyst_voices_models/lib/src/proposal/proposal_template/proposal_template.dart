import 'package:catalyst_voices_models/src/proposal/proposal_template/segments/proposal_template_segments.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_template.g.dart';

@JsonSerializable()
class PropTemplate extends Equatable {
  final String schema;
  final String id;
  final String title;
  final String description;
  final Object definitions;
  final String type;
  final bool additionalProperties;
  final PropTemplateSegments properties;
  @JsonKey(name: 'x-order')
  final List<String> xorder;

  const PropTemplate({
    required this.schema,
    required this.id,
    required this.title,
    required this.description,
    required this.definitions,
    required this.type,
    required this.additionalProperties,
    required this.properties,
    required this.xorder,
  });

  factory PropTemplate.fromJson(Map<String, dynamic> json) =>
      _$PropTemplateFromJson(json);

  @override
  List<Object?> get props => [
        schema,
        id,
        title,
        description,
        definitions,
        type,
        additionalProperties,
        properties,
        xorder,
      ];
}
