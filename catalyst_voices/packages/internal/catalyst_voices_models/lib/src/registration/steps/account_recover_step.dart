part of 'registration_step.dart';

sealed class AccountRecoverStep extends RegistrationStep {
  const AccountRecoverStep();
}

final class RecoverMethodStep extends AccountRecoverStep {
  const RecoverMethodStep();
}

final class SeedPhraseRecoverStep extends AccountRecoverStep {
  final RecoverSeedPhraseStage stage;

  const SeedPhraseRecoverStep({
    this.stage = RecoverSeedPhraseStage.seedPhraseInstructions,
  });

  @override
  bool get isRecoverFlow => true;

  @override
  List<Object?> get props => [stage];
}
