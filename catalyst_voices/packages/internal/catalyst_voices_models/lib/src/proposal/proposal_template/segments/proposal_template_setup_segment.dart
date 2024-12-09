import 'package:catalyst_voices_models/src/proposal/proposal_template/sections/proposer_section.dart';
import 'package:catalyst_voices_models/src/proposal/proposal_template/sections/title_section.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposal_template_setup_segment.g.dart';

@JsonSerializable()
class PropTemplateSetup extends Equatable {
  @JsonKey(name: r'$ref')
  final String ref;
  final String title;
  final String description;
  final PropTemplateSetupProperties properties;
  final List<String> required;

  const PropTemplateSetup({
    required this.ref,
    required this.title,
    required this.description,
    required this.properties,
    required this.required,
  });

  factory PropTemplateSetup.fromJson(Map<String, dynamic> json) =>
      _$PropTemplateSetupFromJson(json);

  @override
  List<Object?> get props => [title, description, properties, required];
}

@JsonSerializable()
class PropTemplateSetupProperties {
  final TitleSection title;
  final ProposerSection proposer;

  const PropTemplateSetupProperties({
    required this.title,
    required this.proposer,
  });

  factory PropTemplateSetupProperties.fromJson(Map<String, dynamic> json) =>
      _$PropTemplateSetupPropertiesFromJson(json);
}
