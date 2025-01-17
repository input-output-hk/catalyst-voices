part of 'registration_step.dart';

sealed class AccountRecoverStep extends RegistrationStep {
  const AccountRecoverStep();
}

final class RecoverMethodStep extends AccountRecoverStep {
  const RecoverMethodStep();
}

final class RecoverWithSeedPhraseStep extends AccountRecoverStep {
  final RecoverWithSeedPhraseStage stage;

  const RecoverWithSeedPhraseStep({
    this.stage = RecoverWithSeedPhraseStage.seedPhraseInstructions,
  });

  @override
  bool get isRecoverFlow => true;

  @override
  List<Object?> get props => [stage];
}
