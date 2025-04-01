import 'package:json_annotation/json_annotation.dart';

part 'remote_api_config.g.dart';

@JsonSerializable(createToJson: false)
final class RemoteApiConfig {
  final String? gatewayUrl;
  final String? reviewsUrl;

  const RemoteApiConfig({
    this.gatewayUrl,
    this.reviewsUrl,
  });

  factory RemoteApiConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteApiConfigFromJson(json);
  }
}
