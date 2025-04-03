import 'package:equatable/equatable.dart';

final class EnvVars extends Equatable {
  final String? envName;
  final String? configUrl;

  const EnvVars({
    this.envName,
    this.configUrl,
  });

  @override
  List<Object?> get props => [
        envName,
        configUrl,
      ];

  EnvVars copyWith({
    String? envName,
    String? configUrl,
  }) {
    return EnvVars(
      envName: envName ?? this.envName,
      configUrl: configUrl ?? this.configUrl,
    );
  }

  EnvVars mergeWith(EnvVars other) {
    return copyWith(
      envName: other.envName,
      configUrl: other.configUrl,
    );
  }
}
