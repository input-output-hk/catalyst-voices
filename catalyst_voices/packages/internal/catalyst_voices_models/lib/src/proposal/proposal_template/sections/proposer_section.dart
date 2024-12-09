import 'package:catalyst_voices_models/src/proposal/proposal_template/topics/applicant_topic.dart';
import 'package:catalyst_voices_models/src/proposal/proposal_template/topics/coproposers_topic.dart';
import 'package:catalyst_voices_models/src/proposal/proposal_template/topics/type_topic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proposer_section.g.dart';

@JsonSerializable()
class ProposerSection {
  @JsonKey(name: r'$ref')
  final String ref;
  final ProposerProperties properties;
  final List<String> required;

  const ProposerSection({
    required this.ref,
    required this.properties,
    required this.required,
  });

  factory ProposerSection.fromJson(Map<String, dynamic> json) =>
      _$ProposerSectionFromJson(json);
}

@JsonSerializable()
class ProposerProperties {
  final ApplicantTopic applicant;
  final TypeTopic type;
  final CoproposersTopic coproposers;

  const ProposerProperties({
    required this.applicant,
    required this.type,
    required this.coproposers,
  });

  factory ProposerProperties.fromJson(Map<String, dynamic> json) =>
      _$ProposerPropertiesFromJson(json);
}
