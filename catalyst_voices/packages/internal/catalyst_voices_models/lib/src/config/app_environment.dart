// ignore_for_file: avoid_print

import 'package:catalyst_voices_models/src/config/env_vars/dart_define_env_vars.dart'
    if (dart.library.js_interop) 'env_vars/web_env_vars.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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

  const AppEnvironment.dev()
      : this._(
          type: AppEnvironmentType.dev,
          // TODO(damian-molinski): update config url
          configUrl: '',
        );

  factory AppEnvironment.fromEnv() {
    final envVars = getEnvVars();
    final envName = envVars.envName;
    final configUrl = envVars.configUrl;

    if (envName == null && kDebugMode) {
      print('ENV -> type not defined! Using fallback');
    }
    if (configUrl == null && kDebugMode) {
      print('ENV -> config url not defined! Using fallback');
    }

    final type = AppEnvironmentType.values.asNameMap()[envName];

    if (type == null && envName != null && kDebugMode) {
      print('ENV -> type[$envName] not supported!');
    }

    final effectiveType = type ?? _fallbackEnvType;
    final effectiveConfigUrl = configUrl ?? _fallbackConfigUrl;

    if (kDebugMode) {
      print('ENV -> type[$effectiveType], configUrl[$effectiveConfigUrl]');
    }

    return AppEnvironment._(
      type: effectiveType,
      configUrl: effectiveConfigUrl,
    );
  }

  const AppEnvironment.preprod()
      : this._(
          type: AppEnvironmentType.preprod,
          // TODO(damian-molinski): update config url
          configUrl: '',
        );

  const AppEnvironment.prod()
      : this._(
          type: AppEnvironmentType.prod,
          // TODO(damian-molinski): update config url
          configUrl: '',
        );

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
