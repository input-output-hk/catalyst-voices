import 'package:catalyst_voices_blocs/src/registration/registration_navigator.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class KeychainCreationController {}

final class RegistrationKeychainCreationController
    implements
        KeychainCreationController,
        RegistrationNavigator<CreateKeychain> {
  CreateKeychainStage _stage;

  RegistrationKeychainCreationController({
    CreateKeychainStage stage = CreateKeychainStage.splash,
  }) : _stage = stage;

  @override
  CreateKeychain? nextStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(_stage);
    final isLast = currentStageIndex == CreateKeychainStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = CreateKeychainStage.values[currentStageIndex + 1];
    final nextStep = CreateKeychain(stage: nextStage);

    _stage = nextStep.stage;

    return nextStep;
  }

  @override
  CreateKeychain? previousStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(_stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = CreateKeychainStage.values[currentStageIndex - 1];
    final previousStep = CreateKeychain(stage: previousStage);

    _stage = previousStep.stage;

    return previousStep;
  }
}
