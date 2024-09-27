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
    final nextStep = switch (_stage) {
      CreateKeychainStage.splash =>
        const CreateKeychain(stage: CreateKeychainStage.instructions),
      CreateKeychainStage.instructions => throw UnimplementedError(),
      CreateKeychainStage.seedPhrase => throw UnimplementedError(),
      CreateKeychainStage.checkSeedPhraseInstructions =>
        throw UnimplementedError(),
      CreateKeychainStage.checkSeedPhrase => throw UnimplementedError(),
      CreateKeychainStage.checkSeedPhraseResult => throw UnimplementedError(),
      CreateKeychainStage.unlockPasswordInstructions =>
        throw UnimplementedError(),
      CreateKeychainStage.unlockPasswordCreate => throw UnimplementedError(),
      CreateKeychainStage.created => null,
    };

    if (nextStep != null) {
      _stage = nextStep.stage;
    }

    return nextStep;
  }

  @override
  CreateKeychain? previousStep() {
    final previousStep = switch (_stage) {
      CreateKeychainStage.splash => null,
      CreateKeychainStage.instructions =>
        const CreateKeychain(stage: CreateKeychainStage.splash),
      CreateKeychainStage.seedPhrase => throw UnimplementedError(),
      CreateKeychainStage.checkSeedPhraseInstructions =>
        throw UnimplementedError(),
      CreateKeychainStage.checkSeedPhrase => throw UnimplementedError(),
      CreateKeychainStage.checkSeedPhraseResult => throw UnimplementedError(),
      CreateKeychainStage.unlockPasswordInstructions =>
        throw UnimplementedError(),
      CreateKeychainStage.unlockPasswordCreate => throw UnimplementedError(),
      CreateKeychainStage.created => throw UnimplementedError(),
    };

    if (previousStep != null) {
      _stage = previousStep.stage;
    }

    return previousStep;
  }
}
