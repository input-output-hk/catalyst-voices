import 'package:json_annotation/json_annotation.dart';

part 'coproposers_topic.g.dart';

@JsonSerializable()
class CoproposersTopic {
  @JsonKey(name: r'$ref')
  final String ref;
  final String title;
  final String description;
  final String guidance;
  final int minItems;
  final int maxItems;

  const CoproposersTopic({
    required this.ref,
    required this.title,
    required this.description,
    required this.guidance,
    required this.minItems,
    required this.maxItems,
  });

  factory CoproposersTopic.fromJson(Map<String, dynamic> json) =>
      _$CoproposersTopicFromJson(json);
}
