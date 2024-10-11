import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/state_data/keychain_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationState extends Equatable {
  final RegistrationStep step;
  final KeychainStateData keychainStateData;
  final WalletLinkStateData walletLinkStateData;
  final RecoverStateData recoverStateData;

  const RegistrationState({
    this.step = const GetStartedStep(),
    this.keychainStateData = const KeychainStateData(),
    this.walletLinkStateData = const WalletLinkStateData(),
    this.recoverStateData = const RecoverStateData(),
  });

  double? get progress {
    double getCreateKeychainProgress(CreateKeychainStage stage) {
      final current = CreateKeychainStage.values.indexOf(stage);
      final total = CreateKeychainStage.values.length;
      return current / total;
    }

    double getWalletLinkProgress(WalletLinkStage stage) {
      final current = WalletLinkStage.values.indexOf(stage);
      final total = WalletLinkStage.values.length;
      return current / total;
    }

    double getRecoverSeedProgress(RecoverSeedPhraseStage stage) {
      final current = RecoverSeedPhraseStage.values.indexOf(stage) + 1;
      final total = RecoverSeedPhraseStage.values.length;
      return current / total;
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverMethodStep() => null,
      SeedPhraseRecoverStep(:final stage) => getRecoverSeedProgress(stage),
      CreateKeychainStep(:final stage) => getCreateKeychainProgress(stage),
      FinishAccountCreationStep() => 1.0,
      WalletLinkStep(:final stage) => getWalletLinkProgress(stage),
      AccountCompletedStep() => 1.0,
    };
  }

  RegistrationState copyWith({
    RegistrationStep? step,
    KeychainStateData? keychainStateData,
    WalletLinkStateData? walletLinkStateData,
    RecoverStateData? recoverStateData,
  }) {
    return RegistrationState(
      step: step ?? this.step,
      keychainStateData: keychainStateData ?? this.keychainStateData,
      walletLinkStateData: walletLinkStateData ?? this.walletLinkStateData,
      recoverStateData: recoverStateData ?? this.recoverStateData,
    );
  }

  @override
  List<Object?> get props => [
        step,
        keychainStateData,
        walletLinkStateData,
        recoverStateData,
      ];
}
