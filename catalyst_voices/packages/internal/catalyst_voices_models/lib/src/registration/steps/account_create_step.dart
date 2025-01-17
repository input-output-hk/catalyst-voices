part of 'registration_step.dart';

sealed class AccountCreateStep extends RegistrationStep {
  const AccountCreateStep();
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
final class FinishAccountCreationStep extends AccountCreateStep {
  const FinishAccountCreationStep();

  @override
  bool get isRegistrationFlow => true;
}

// TODO(damian-molinski): Account Created
final class AccountCompletedStep extends AccountCreateStep {
  const AccountCompletedStep();
}
