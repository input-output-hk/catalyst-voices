import 'package:catalyst_voices_blocs/src/registration/seed_phrase_state.dart';
import 'package:catalyst_voices_blocs/src/registration/wallet_link_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Determines the state of registration flow.
/// It consists of 4 separate steps
///   - [GetStarted] which is first one.
///   - [FinishAccountCreation] is special step in case of partially created
///   account.
///   - [Recover] when want to start with existing one.
///   - [CreateNew] is entire flow in it self and has two distinguish sub-steps
///     - [CreateKeychain] where user is creating new keychain.
///     - [WalletLink] where user is linking Keychain with wallet.
///   - [AccountCompleted] after all previous steps succeeded.
sealed class RegistrationState extends Equatable {
  const RegistrationState();

  RegistrationStep get step;

  double? get progress => null;

  @override
  List<Object?> get props => [];
}

/// User decides where to go here [CreateNew] or [Recover] route.
final class GetStarted extends RegistrationState {
  const GetStarted();

  @override
  GetStartedStep get step => const GetStartedStep();
}

/// When [CreateKeychain] is completed but [WalletLink] not.
final class FinishAccountCreation extends RegistrationState {
  const FinishAccountCreation();

  @override
  FinishAccountCreationStep get step => const FinishAccountCreationStep();
}

/// User enters existing seed phrase here.
final class Recover extends RegistrationState {
  const Recover();

  @override
  RecoverStep get step => const RecoverStep();
}

/// Encapsulates entire process of registration.
sealed class CreateNew extends RegistrationState {
  const CreateNew();
}

/// Building up information for creating new Keychain.
final class CreateKeychain extends CreateNew {
  final CreateKeychainStage stage;
  final SeedPhraseState seedPhraseState;

  const CreateKeychain({
    this.stage = CreateKeychainStage.splash,
    this.seedPhraseState = const SeedPhraseState(),
  });

  @override
  CreateKeychainStep get step => CreateKeychainStep(stage: stage);

  @override
  double get progress {
    final current = CreateKeychainStage.values.indexOf(stage);
    final total = CreateKeychainStage.values.length;
    return current / total;
  }

  @override
  List<Object?> get props =>
      super.props +
      [
        stage,
        seedPhraseState,
      ];
}

/// Linking existing keychain with wallet.
final class WalletLink extends CreateNew {
  final WalletLinkStage stage;
  final WalletLinkStateData state;

  const WalletLink({
    this.stage = WalletLinkStage.intro,
    this.state = const WalletLinkStateData(),
  });

  @override
  WalletLinkStep get step => WalletLinkStep(stage: stage);

  @override
  double get progress {
    final current = WalletLinkStage.values.indexOf(stage);
    final total = WalletLinkStage.values.length;
    return current / total;
  }

  @override
  List<Object?> get props =>
      super.props +
      [
        stage,
        state,
      ];
}

final class AccountCompleted extends RegistrationState {
  const AccountCompleted();

  @override
  AccountCompletedStep get step => const AccountCompletedStep();
}
