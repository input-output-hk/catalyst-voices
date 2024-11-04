import 'package:catalyst_voices_shared/src/common/build_environment.dart';

/// `BuildConfig` holds configuration values for the application.
///
/// To pass configuration values to the application,
/// set the environment variables
/// with `--dart define` when running the application:
/// ```
/// flutter run --dart-define SENTRY_DSN=https://dev.api.example.com --dart-define SENTRY_ENVIRONMENT=qa
/// ```
/// To access the environment variables, use the `BuildConfig` class.
/// For example, to get the `SENTRY_DSN` environment variable,
///  use `AppConfig.sentryDsn`.
final class BuildConfig {
  /// Gets the 'SENTRY_DSN' from the environment variables.
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
  );

  /// Gets the 'SENTRY_ENVIRONMENT' from the environment variables.
  /// If 'SENTRY_ENVIRONMENT' is not set in the environment variables,
  /// it defaults to 'dev'.
  static String sentryEnvironment = String.fromEnvironment(
    BuildEnvironment.fromEnvironment('SENTRY_ENVIRONMENT'),
  );

  /// Gets the 'SENTRY_RELEASE' from the environment variables.
  static const String sentryRelease = String.fromEnvironment(
    'SENTRY_RELEASE',
  );

  BuildConfig._();
}
