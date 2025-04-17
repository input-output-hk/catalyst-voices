import 'package:catalyst_voices_models/src/config/env_vars/env_vars.dart';
import 'package:flutter/services.dart';

/// Have to mach against --dart-define variables
const _envNameKey = 'ENV_NAME';

EnvVars getDartEnvVars() {
  const envName = bool.hasEnvironment(_envNameKey)
      ? String.fromEnvironment(_envNameKey)
      : null;

  return const EnvVars(
    envName: envName ?? appFlavor,
  );
}
