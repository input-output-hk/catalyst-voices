import 'package:json_annotation/json_annotation.dart';

part 'remote_sentry_config.g.dart';

@JsonSerializable(createToJson: false)
final class RemoteSentryConfig {
  final String? dsn;
  final String? environment;
  final String? release;
  final double? tracesSampleRate;
  final double? profilesSampleRate;
  final bool? enableAutoSessionTracking;
  final bool? attachViewHierarchy;
  final String? diagnosticLevel;

  const RemoteSentryConfig({
    this.dsn,
    this.environment,
    this.release,
    this.tracesSampleRate,
    this.profilesSampleRate,
    this.enableAutoSessionTracking,
    this.attachViewHierarchy,
    this.diagnosticLevel,
  });

  factory RemoteSentryConfig.fromJson(Map<String, dynamic> json) {
    return _$RemoteSentryConfigFromJson(json);
  }
}
