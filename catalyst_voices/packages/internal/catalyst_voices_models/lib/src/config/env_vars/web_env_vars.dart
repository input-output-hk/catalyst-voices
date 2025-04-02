//ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:catalyst_voices_models/src/config/env_vars/env_vars.dart';

const _configUrlKey = 'CONFIG_URL';
const _configUrlPlaceholder = '{{$_configUrlKey}}';
const _envNameKey = 'ENV_NAME';
const _envNamePlaceholder = '{{$_envNameKey}}';

EnvVars getEnvVars() {
  final flutterEnvironment = globalContext['flutterEnvironment']?.dartify();
  if (flutterEnvironment is! Map) {
    return const EnvVars();
  }

  final configUrl = flutterEnvironment[_configUrlKey] as String?;
  final envName = flutterEnvironment[_envNameKey] as String?;

  final effectiveEnvName = envName == _envNamePlaceholder ? null : envName;
  final effectiveConfigUrl =
      configUrl == _configUrlPlaceholder ? null : configUrl;

  return EnvVars(
    envName: effectiveEnvName,
    configUrl: effectiveConfigUrl,
  );
}
