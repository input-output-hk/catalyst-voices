import 'package:json_annotation/json_annotation.dart';

part 'type_topic.g.dart';

@JsonSerializable()
class TypeTopic {
  @JsonKey(name: r'$ref')
  final String ref;
  final String title;
  final String description;
  final String guidance;
  final List<String> enumValues;
  final String defaultValue;

  const TypeTopic({
    required this.ref,
    required this.title,
    required this.description,
    required this.guidance,
    required this.enumValues,
    required this.defaultValue,
  });

  factory TypeTopic.fromJson(Map<String, dynamic> json) =>
      _$TypeTopicFromJson(json);
}
