import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
final class ErrorResponse {
  final String detail;

  const ErrorResponse({required this.detail});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return _$ErrorResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
