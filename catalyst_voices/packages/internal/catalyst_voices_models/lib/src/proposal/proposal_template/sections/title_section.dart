import 'package:catalyst_voices_models/src/proposal/proposal_template/topics/title_topic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'title_section.g.dart';

@JsonSerializable()
class TitleSection {
  @JsonKey(name: r'$ref')
  final String ref;
  final String title;
  final String description;
  final TitleProperties properties;

  const TitleSection({
    required this.title,
    required this.ref,
    required this.description,
    required this.properties,
  });

  factory TitleSection.fromJson(Map<String, dynamic> json) =>
      _$TitleSectionFromJson(json);
}

@JsonSerializable()
class TitleProperties {
  final TitleTopic title;

  const TitleProperties({
    required this.title,
  });

  factory TitleProperties.fromJson(Map<String, dynamic> json) =>
      _$TitlePropertiesFromJson(json);
}
