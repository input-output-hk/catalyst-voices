import 'package:catalyst_voices_models/src/registration/create_keychain_stage.dart';
import 'package:catalyst_voices_models/src/registration/wallet_link_stage.dart';
import 'package:equatable/equatable.dart';

/// Represents only step of registration, not stage of this step.
sealed class RegistrationStep extends Equatable {
  const RegistrationStep();

  @override
  List<Object?> get props => [];
}

final class GetStartedStep extends RegistrationStep {
  const GetStartedStep();
}

final class FinishAccountCreationStep extends RegistrationStep {
  const FinishAccountCreationStep();
}

final class RecoverStep extends RegistrationStep {
  const RecoverStep();
}

final class CreateKeychainStep extends RegistrationStep {
  final CreateKeychainStage stage;

  const CreateKeychainStep({
    this.stage = CreateKeychainStage.splash,
  });

  @override
  List<Object?> get props => [stage];
}

final class WalletLinkStep extends RegistrationStep {
  final WalletLinkStage stage;

  const WalletLinkStep({
    this.stage = WalletLinkStage.intro,
  });

  @override
  List<Object?> get props => [stage];
}

final class AccountCompletedStep extends RegistrationStep {
  const AccountCompletedStep();
}
