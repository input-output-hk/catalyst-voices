// ignore_for_file: avoid_print

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Have to mach against --dart-define variables
const _envVarConfigUrl = 'API_URL';
const _envVarType = 'ENV_NAME';

// TODO(damian-molinski): provide valid url
const _fallbackConfigUrl = '';
const _fallbackEnvType = AppEnvironmentType.dev;

final class AppEnvironment extends Equatable {
  final AppEnvironmentType type;
  final String configUrl;

  @visibleForTesting
  const AppEnvironment.custom({
    required this.type,
    required this.configUrl,
  });

  const AppEnvironment.fallback()
      : this._(
          type: _fallbackEnvType,
          configUrl: _fallbackConfigUrl,
        );

  factory AppEnvironment.fromEnv() {
    const envTypeName = bool.hasEnvironment(_envVarType)
        ? String.fromEnvironment(_envVarType)
        : null;
    const envConfigUrl = bool.hasEnvironment(_envVarConfigUrl)
        ? String.fromEnvironment(_envVarConfigUrl)
        : null;

    if (envTypeName == null && kDebugMode) {
      print('Env name not defined! Using fallback');
    }
    if (envConfigUrl == null && kDebugMode) {
      print('Config url not defined! Using fallback');
    }

    final type = AppEnvironmentType.values.asNameMap()[envTypeName];

    if (type == null && envTypeName != null && kDebugMode) {
      print('Env name[$envTypeName] not supported!');
    }

    return AppEnvironment._(
      type: type ?? _fallbackEnvType,
      configUrl: envConfigUrl ?? _fallbackConfigUrl,
    );
  }

  const AppEnvironment._({
    required this.type,
    required this.configUrl,
  });

  @override
  List<Object?> get props => [type, configUrl];
}

enum AppEnvironmentType {
  dev,
  preprod,
  prod;
}
