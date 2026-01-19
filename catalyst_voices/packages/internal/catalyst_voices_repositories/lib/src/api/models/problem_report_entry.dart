import 'package:json_annotation/json_annotation.dart';

part 'problem_report_entry.g.dart';

/// Represents an `OpenAPI` object for a Problem Report entry.
@JsonSerializable()
final class ProblemReportEntry {
  /// The kind of problem we are recording.
  final String kind;

  /// The message describing the problem.
  final String msg;

  /// The field name that causes the problem.
  final String? field;

  /// The value of the field.
  final String? value;

  /// The constraint of what is expected for a valid value
  final String? constraint;

  /// Detected encoding
  final String? encoded;

  /// Expected encoding
  final String? expected;

  /// Explanation of the failed or problematic validation
  final String? explanation;

  /// Additional information about the duplicate field.
  final String? description;

  /// The type that the value was expected to convert to
  @JsonKey(name: 'expected_type')
  final String? expectedType;

  const ProblemReportEntry({
    required this.kind,
    required this.msg,
    this.field,
    this.value,
    this.constraint,
    this.encoded,
    this.expected,
    this.explanation,
    this.description,
    this.expectedType,
  });

  factory ProblemReportEntry.fromJson(Map<String, dynamic> json) =>
      _$ProblemReportEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemReportEntryToJson(this);
}
