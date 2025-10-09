import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_models/src/config/env_vars/env_vars.dart';

/// Have to mach against --dart-define variables
const _envNameKey = 'ENV_NAME';

/// Returns [AppEnvironmentType] settings from Dart's environment variables.
EnvVars getDartEnvVars() {
  const envName = bool.hasEnvironment(_envNameKey) ? String.fromEnvironment(_envNameKey) : null;

  return const EnvVars(
    // ignore: avoid_redundant_argument_values
    envName: envName,
  );
}
