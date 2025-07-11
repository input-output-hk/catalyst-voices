import 'package:catalyst_voices_models/src/config/env_vars/dart_define_env_vars.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Fallback environment type used when an environment cannot be determined.
/// Defaults to [AppEnvironmentType.relative] on web and [AppEnvironmentType.dev]
/// on other platforms.
const _fallbackEnvType = kIsWeb ? AppEnvironmentType.relative : AppEnvironmentType.dev;

/// The base domain for the Project Catalyst services.
const _projectCatalyst = 'projectcatalyst.io';

/// A regular expression to parse the environment name from a hostname.
/// e.g., "app.dev.projectcatalyst.io" -> "dev"
final _envRegExp = RegExp(r'app\.([a-z]+)\.projectcatalyst\.io', caseSensitive: false);

/// Represents the application's current runtime environment.
///
/// This class provides a structured way to manage different deployment environments
/// like development, pre-production, and production. It determines the
/// environment from Dart's compile-time environment variables or the host URL.
final class AppEnvironment extends Equatable {
  /// The specific type of the current environment.
  final AppEnvironmentType type;

  /// Creates an [AppEnvironment] with a custom environment type.
  ///
  /// This constructor is primarily for testing purposes, allowing the injection
  /// of a specific environment type.
  @visibleForTesting
  const AppEnvironment.custom({
    required this.type,
  });

  /// Creates a [AppEnvironmentType.dev] environment configuration.
  const AppEnvironment.dev() : this._(type: AppEnvironmentType.dev);

  /// Creates an [AppEnvironment] by reading Dart's environment variables.
  ///
  /// It looks for an 'envName' variable and maps it to an [AppEnvironmentType].
  /// If the variable is not found or is unsupported, it falls back to [_fallbackEnvType].
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

  /// Creates a [AppEnvironmentType.preprod] environment configuration.
  const AppEnvironment.preprod() : this._(type: AppEnvironmentType.preprod);

  /// Creates a [AppEnvironmentType.prod] environment configuration.
  const AppEnvironment.prod() : this._(type: AppEnvironmentType.prod);

  /// Creates a [AppEnvironmentType.relative] environment configuration.
  ///
  /// This is typically used for web builds where the backend services are
  /// located relative to the web app's hosting domain.
  const AppEnvironment.relative() : this._(type: AppEnvironmentType.relative);

  const AppEnvironment._({
    required this.type,
  });

  @override
  List<Object?> get props => [type];
}

/// Defines the different deployment environments the application can run in.
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

  /// Gets the base URI for the main application services.
  ///
  /// For [relative], it returns an empty URI as the base is determined at runtime
  /// from the browser's URL.
  Uri get app {
    return switch (this) {
      AppEnvironmentType.dev || AppEnvironmentType.preprod => _getBaseUrl('app', envName: name),
      AppEnvironmentType.prod => _getBaseUrl('app'),

      /// [AppEnvironmentType.relative] type does not now where its backends
      /// are hosted.
      AppEnvironmentType.relative => Uri(),
    };
  }

  /// Gets the base URI for the reviews service.
  ///
  /// For [relative], it attempts to parse the environment name from the
  /// browser's current URL ([Uri.base]).
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

  /// Constructs a base URL from a service name and an optional environment name.
  ///
  /// Example: `_getBaseUrl('api', envName: 'dev')` -> `https://api.dev.projectcatalyst.io`
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

  /// Tries to extract the environment name from a given URI string.
  ///
  /// It uses [_envRegExp] to find a match (e.g., 'dev', 'preprod') and
  /// returns it if the found value corresponds to a valid [AppEnvironmentType].
  /// Returns `null` if no valid environment name is found.
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
