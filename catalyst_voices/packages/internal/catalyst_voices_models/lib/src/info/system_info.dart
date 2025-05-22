import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SystemInfo extends Equatable {
  final AppInfo? app;
  final GatewayInfo? gateway;
  final AppConfig? config;

  const SystemInfo({
    this.app,
    this.gateway,
    this.config,
  });

  @override
  List<Object?> get props => [
        app,
        gateway,
        config,
      ];

  SystemInfo copyWith({
    Optional<AppInfo>? app,
    Optional<GatewayInfo>? gateway,
    Optional<AppConfig>? config,
  }) {
    return SystemInfo(
      app: app.dataOr(this.app),
      gateway: gateway.dataOr(this.gateway),
      config: config.dataOr(this.config),
    );
  }
}
