import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' show AppConfig;

Future<void> registerForTests({
  AppConfig? config,
}) async {
  await registerDependencies();
  registerConfig(config ?? AppConfig.dev());
}

Future<void> restartForTests() async {
  await restartDependencies();
}
