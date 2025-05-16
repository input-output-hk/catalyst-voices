import 'package:equatable/equatable.dart';

final class EnvVars extends Equatable {
  final String? envName;

  const EnvVars({
    this.envName,
  });

  @override
  List<Object?> get props => [
        envName,
      ];

  EnvVars copyWith({
    String? envName,
  }) {
    return EnvVars(
      envName: envName ?? this.envName,
    );
  }

  EnvVars mergeWith(EnvVars other) {
    return copyWith(
      envName: other.envName,
    );
  }
}
