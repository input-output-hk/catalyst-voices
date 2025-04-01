import 'package:json_annotation/json_annotation.dart';

part 'remote_sentry_config.g.dart';

@JsonSerializable(createToJson: false)
final class RemoteSentryConfig {
  final String? dns;
  final String? environment;
  final String? release;
  final double? tracesSampleRate;
  final double? profilesSampleRate;
  final bool? enableAutoSessionTracking;
  final bool? attachScreenshot;
  final bool? attachViewHierarchy;
  final bool? debug;
  final String? diagnosticLevel;

  const RemoteSentryConfig({
    this.dns,
    this.environment,
    this.release,
    this.tracesSampleRate,
    this.profilesSampleRate,
    this.enableAutoSessionTracking,
    this.attachScreenshot,
    this.attachViewHierarchy,
    this.debug,
    this.diagnosticLevel,
  });

  factory RemoteSentryConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteSentryConfigFromJson(json);
  }
}
