import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/state_data/keychain_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationState extends Equatable {
  final RegistrationStep step;
  final KeychainStateData keychainStateData;
  final WalletLinkStateData walletLinkStateData;
  final RegistrationStateData registrationStateData;
  final RecoverStateData recoverStateData;

  const RegistrationState({
    this.step = const GetStartedStep(),
    this.keychainStateData = const KeychainStateData(),
    this.walletLinkStateData = const WalletLinkStateData(),
    this.registrationStateData = const RegistrationStateData(),
    this.recoverStateData = const RecoverStateData(),
  });

  double? get progress {
    double createBaseProfileProgress(CreateBaseProfileStage stage) {
      final current = CreateBaseProfileStage.values.indexOf(stage);
      final total = CreateBaseProfileStage.values.length;
      return current / total;
    }

    double createKeychainProgress(CreateKeychainStage stage) {
      final current = CreateKeychainStage.values.indexOf(stage);
      final total = CreateKeychainStage.values.length;
      return current / total;
    }

    double walletLinkProgress(WalletLinkStage stage) {
      final current = WalletLinkStage.values.indexOf(stage);
      final total = WalletLinkStage.values.length;
      return current / total;
    }

    double recoverWithSeedProgress(RecoverWithSeedPhraseStage stage) {
      final current = RecoverWithSeedPhraseStage.values.indexOf(stage) + 1;
      final total = RecoverWithSeedPhraseStage.values.length;
      return current / total;
    }

    return switch (step) {
      GetStartedStep() => null,
      // recovery
      RecoverMethodStep() => null,
      RecoverWithSeedPhraseStep(:final stage) => recoverWithSeedProgress(stage),

      // account creation
      CreateBaseProfileStep(:final stage) => createBaseProfileProgress(stage),
      CreateKeychainStep(:final stage) => createKeychainProgress(stage),
      AccountCreateProgressStep() => 1.0,
      WalletLinkStep(:final stage) => walletLinkProgress(stage),

      // ready
      AccountCompletedStep() => 1.0,
    };
  }

  RegistrationState copyWith({
    RegistrationStep? step,
    KeychainStateData? keychainStateData,
    WalletLinkStateData? walletLinkStateData,
    RegistrationStateData? registrationStateData,
    RecoverStateData? recoverStateData,
  }) {
    return RegistrationState(
      step: step ?? this.step,
      keychainStateData: keychainStateData ?? this.keychainStateData,
      walletLinkStateData: walletLinkStateData ?? this.walletLinkStateData,
      registrationStateData:
          registrationStateData ?? this.registrationStateData,
      recoverStateData: recoverStateData ?? this.recoverStateData,
    );
  }

  @override
  List<Object?> get props => [
        step,
        keychainStateData,
        walletLinkStateData,
        registrationStateData,
        recoverStateData,
      ];
}
