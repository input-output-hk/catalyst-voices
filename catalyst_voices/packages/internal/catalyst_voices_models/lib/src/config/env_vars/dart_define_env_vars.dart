import 'package:catalyst_voices_models/src/config/env_vars/env_vars.dart';

/// Have to mach against --dart-define variables
const _configUrlKey = 'CONFIG_URL';
const _envNameKey = 'ENV_NAME';

EnvVars getDartEnvVars() {
  const envName = bool.hasEnvironment(_envNameKey)
      ? String.fromEnvironment(_envNameKey)
      : null;
  const configUrl = bool.hasEnvironment(_configUrlKey)
      ? String.fromEnvironment(_configUrlKey)
      : null;

  return const EnvVars(
    envName: envName,
    configUrl: configUrl,
  );
}
