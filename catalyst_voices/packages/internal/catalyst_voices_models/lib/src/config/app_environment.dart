import 'package:catalyst_voices_models/src/config/env_vars/dart_define_env_vars.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const _fallbackEnvType = kIsWeb ? AppEnvironmentType.relative : AppEnvironmentType.dev;
const _projectCatalyst = 'projectcatalyst.io';
final _envRegExp = RegExp(r'app\.([a-z]+)\.projectcatalyst\.io', caseSensitive: false);

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

/// See https://github.com/input-output-hk/catalyst-internal-docs/issues/178
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

  Uri get app {
    return switch (this) {
      AppEnvironmentType.dev || AppEnvironmentType.preprod => _getBaseUrl('app', envName: name),
      AppEnvironmentType.prod => _getBaseUrl('app'),

      /// [AppEnvironmentType.relative] type does not now where its backends
      /// are hosted.
      AppEnvironmentType.relative => Uri(),
    };
  }

  Uri get reviews {
    return switch (this) {
      AppEnvironmentType.dev || AppEnvironmentType.preprod => _getBaseUrl('reviews', envName: name),
      AppEnvironmentType.prod => _getBaseUrl('reviews'),
      AppEnvironmentType.relative => _getBaseUrl(
          'reviews',
          envName: tryUriBaseEnvName(from: Uri.base.toString()),
        ),
    };
  }

  Uri _getBaseUrl(
    String name, {
    String? envName,
  }) {
    final parts = [
      name,
      if (envName != null) envName,
      _projectCatalyst,
    ];

    final authority = parts.join('.');

    return Uri.https(authority);
  }

  @visibleForTesting
  static String? tryUriBaseEnvName({required String from}) {
    final match = _envRegExp.firstMatch(from);
    if (match != null && match.groupCount >= 1) {
      final value = match.group(1)!;
      if (AppEnvironmentType.values.any((element) => element.name == value)) {
        return value;
      }
    }

    return null;
  }
}
