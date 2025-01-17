part of 'registration_step.dart';

sealed class AccountCreateStep extends RegistrationStep {
  const AccountCreateStep();
}

final class CreateBaseProfileStep extends AccountCreateStep {
  final CreateBaseProfileStage stage;

  const CreateBaseProfileStep({
    this.stage = CreateBaseProfileStage.instructions,
  });

  @override
  bool get isRegistrationFlow => true;

  @override
  List<Object?> get props => [stage];
}

final class CreateKeychainStep extends AccountCreateStep {
  final CreateKeychainStage stage;

  const CreateKeychainStep({
    this.stage = CreateKeychainStage.splash,
  });

  @override
  bool get isRegistrationFlow => true;

  @override
  List<Object?> get props => [stage];
}

final class WalletLinkStep extends AccountCreateStep {
  final WalletLinkStage stage;

  const WalletLinkStep({
    this.stage = WalletLinkStage.intro,
  });

  @override
  bool get isRegistrationFlow => true;

  @override
  List<Object?> get props => [stage];
}

// TODO(damian-molinski): Create Account Step Completed.
// TODO(damian-molinski): Needs parameter about which step is completed.
final class FinishAccountCreationStep extends AccountCreateStep {
  const FinishAccountCreationStep();
}
