import 'package:catalyst_voices_models/src/config/env_vars/dart_define_env_vars.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const _fallbackEnvType = kIsWeb ? AppEnvironmentType.relative : AppEnvironmentType.dev;

final class AppEnvironment extends Equatable {
  final AppEnvironmentType type;

  @visibleForTesting
  const AppEnvironment.custom({
    required this.type,
  });

  const AppEnvironment.dev() : this._(type: AppEnvironmentType.dev);

  factory AppEnvironment.fromEnv() {
    final envVars = getDartEnvVars();
    final envName = envVars.envName;
    final type = AppEnvironmentType.values.asNameMap()[envName];

    if (type == null && envName != null) {
      if (kDebugMode) {
        print('ENV -> Found envName[$envName] but its not supported!');
      }
    }

    final effectiveType = type ?? _fallbackEnvType;

    if (kDebugMode) {
      print('ENV -> type[$effectiveType]');
    }

    return AppEnvironment._(type: effectiveType);
  }

  const AppEnvironment.preprod() : this._(type: AppEnvironmentType.preprod);

  const AppEnvironment.prod() : this._(type: AppEnvironmentType.prod);

  const AppEnvironment.relative() : this._(type: AppEnvironmentType.relative);

  const AppEnvironment._({
    required this.type,
  });

  @override
  List<Object?> get props => [type];
}

enum AppEnvironmentType {
  /// This type tells app to always talk to full, hardcoded dev backend
  /// url.
  ///
  /// Useful when building app locally at localhost but you want to
  /// test against dev env.
  dev,

  /// Same as [dev] but for preprod.
  preprod,

  /// Same as [dev] but for prod.
  prod,

  /// This type means app should talk to cat services relative to where its
  /// hosted.
  ///
  /// For example when hosted at "https://app.projectcatalyst.io" talk to
  /// "https://app.projectcatalyst.io/api/gateway".
  ///
  /// It useful when building app one time and it can be deployed anywhere.
  relative;

  /// See https://github.com/input-output-hk/catalyst-internal-docs/issues/178
  Uri get baseUrl {
    return switch (this) {
      AppEnvironmentType.dev ||
      AppEnvironmentType.preprod =>
        Uri.https('app.$name.projectcatalyst.io'),
      AppEnvironmentType.prod => Uri.https('app.projectcatalyst.io'),

      /// [AppEnvironmentType.relative] type does not now where its backends
      /// are hosted.
      AppEnvironmentType.relative => Uri(),
    };
  }

  /// See https://github.com/input-output-hk/catalyst-internal-docs/issues/178
  Uri get gateway => baseUrl.replace(path: '/api/gateway');

  /// See https://github.com/input-output-hk/catalyst-internal-docs/issues/178
  Uri get reviews => baseUrl.replace(path: '/api/reviews');
}
