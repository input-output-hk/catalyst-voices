part of 'registration_step.dart';

enum AccountCreateStepType { baseProfile, keychain, walletLink }

sealed class AccountCreateStep extends RegistrationStep {
  final AccountCreateStepType type;

  const AccountCreateStep({
    required this.type,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [type];
}

final class CreateBaseProfileStep extends AccountCreateStep {
  final CreateBaseProfileStage stage;

  const CreateBaseProfileStep({
    this.stage = CreateBaseProfileStage.instructions,
  }) : super(
          type: AccountCreateStepType.baseProfile,
        );

  @override
  List<Object?> get props => [...super.props, stage];
}

final class CreateKeychainStep extends AccountCreateStep {
  final CreateKeychainStage stage;

  const CreateKeychainStep({
    this.stage = CreateKeychainStage.splash,
  }) : super(
          type: AccountCreateStepType.keychain,
        );

  @override
  List<Object?> get props => [...super.props, stage];
}

final class WalletLinkStep extends AccountCreateStep {
  final WalletLinkStage stage;

  const WalletLinkStep({
    this.stage = WalletLinkStage.intro,
  }) : super(
          type: AccountCreateStepType.walletLink,
        );

  @override
  List<Object?> get props => [...super.props, stage];
}

final class AccountCreateProgressStep extends RegistrationStep {
  final List<AccountCreateStepType> completedSteps;

  const AccountCreateProgressStep({
    required this.completedSteps,
  });

  @override
  List<Object?> get props => [completedSteps];
}
