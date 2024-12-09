import 'package:json_annotation/json_annotation.dart';

part 'title_topic.g.dart';

@JsonSerializable()
class TitleTopic {
  @JsonKey(name: r'$ref')
  final String ref;
  final String title;
  final String description;
  final int minLength;
  final int maxLength;
  final String guidance;

  const TitleTopic({
    required this.ref,
    required this.title,
    required this.description,
    required this.minLength,
    required this.maxLength,
    required this.guidance,
  });

  factory TitleTopic.fromJson(Map<String, dynamic> json) =>
      _$TitleTopicFromJson(json);
}
