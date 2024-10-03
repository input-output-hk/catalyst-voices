import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/state_data/keychain_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationState extends Equatable {
  final RegistrationStep step;
  final KeychainStateData keychainStateData;
  final WalletLinkStateData walletLinkStateData;

  const RegistrationState({
    this.step = const GetStartedStep(),
    this.keychainStateData = const KeychainStateData(),
    this.walletLinkStateData = const WalletLinkStateData(),
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

    return switch (step) {
      GetStartedStep() => null,
      RecoverStep() => null,
      CreateKeychainStep(:final stage) => getCreateKeychainProgress(stage),
      FinishAccountCreationStep() => 1.0,
      WalletLinkStep(:final stage) => getWalletLinkProgress(stage),
      AccountCompletedStep() => null,
    };
  }

  RegistrationState copyWith({
    RegistrationStep? step,
    KeychainStateData? keychainStateData,
    WalletLinkStateData? walletLinkStateData,
  }) {
    return RegistrationState(
      step: step ?? this.step,
      keychainStateData: keychainStateData ?? this.keychainStateData,
      walletLinkStateData: walletLinkStateData ?? this.walletLinkStateData,
    );
  }

  @override
  List<Object?> get props => [
        step,
        keychainStateData,
        walletLinkStateData,
      ];
}
