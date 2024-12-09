import 'package:catalyst_voices_models/src/proposal/proposal_template/segments/proposal_template_setup_segment.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_template_segments.g.dart';

@JsonSerializable()
class PropTemplateSegments extends Equatable {
  @JsonKey(name: r'$schema')
  final SchemaProperty schema;
  final PropTemplateSetup setup;

  const PropTemplateSegments({
    required this.schema,
    required this.setup,
  });

  factory PropTemplateSegments.fromJson(Map<String, dynamic> json) =>
      _$PropTemplateSegmentsFromJson(json);

  @override
  List<Object?> get props => [];
}

@JsonSerializable()
class SchemaProperty extends Equatable {
  @JsonKey(name: r'$schema')
  final String schema;
  @JsonKey(name: r'$id')
  final String id;
  final String title;
  final String description;

  const SchemaProperty({
    required this.schema,
    required this.id,
    required this.title,
    required this.description,
  });

  factory SchemaProperty.fromJson(Map<String, dynamic> json) =>
      _$SchemaPropertyFromJson(json);

  @override
  List<Object?> get props => [schema, id, title, description];
}
