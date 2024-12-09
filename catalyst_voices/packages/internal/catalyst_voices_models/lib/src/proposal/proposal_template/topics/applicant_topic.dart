import 'package:json_annotation/json_annotation.dart';

part 'applicant_topic.g.dart';

@JsonSerializable()
class ApplicantTopic {
  @JsonKey(name: r'$ref')
  final String ref;
  final String title;
  final String description;
  final String guidance;
  final int minLength;
  final int maxLength;

  ApplicantTopic({
    required this.ref,
    required this.title,
    required this.description,
    required this.guidance,
    required this.minLength,
    required this.maxLength,
  });

  factory ApplicantTopic.fromJson(Map<String, dynamic> json) =>
      _$ApplicantTopicFromJson(json);
}
