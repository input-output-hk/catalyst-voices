import 'package:json_annotation/json_annotation.dart';

part 'remote_api_config.g.dart';

@JsonSerializable(createToJson: false)
final class RemoteApiConfig {
  final String? gateway;
  final String? reviews;

  const RemoteApiConfig({
    this.gateway,
    this.reviews,
  });

  factory RemoteApiConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteApiConfigFromJson(json);
  }
}
