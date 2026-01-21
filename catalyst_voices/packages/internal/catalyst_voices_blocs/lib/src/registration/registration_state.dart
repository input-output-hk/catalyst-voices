import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class RegistrationState extends Equatable {
  final RegistrationStep step;
  final RegistrationGetStartedState getStarted;
  final BaseProfileStateData baseProfileStateData;
  final KeychainStateData keychainStateData;
  final WalletLinkStateData walletLinkStateData;
  final RegistrationStateData registrationStateData;
  final RecoverStateData recoverStateData;
  final Result<AccountSummaryData, LocalizedException>? walletDrepLinkAccountDetails;

  const RegistrationState({
    this.step = const GetStartedStep(),
    this.getStarted = const RegistrationGetStartedState(),
    this.baseProfileStateData = const BaseProfileStateData(),
    this.keychainStateData = const KeychainStateData(),
    this.walletLinkStateData = const WalletLinkStateData(),
    this.registrationStateData = const RegistrationStateData(),
    this.recoverStateData = const RecoverStateData(),
    this.walletDrepLinkAccountDetails,
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

    double walletDrepLinkProgress(WalletDrepLinkStage stage) {
      final current = WalletDrepLinkStage.values.indexOf(stage);
      final total = WalletDrepLinkStage.values.length;
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

      // account update
      WalletDrepLinkStep(:final stage) => walletDrepLinkProgress(stage),

      // ready
      AccountCompletedStep() => 1.0,
      WalletDrepLinkCompletedStep() => 1.0,
    };
  }

  @override
  List<Object?> get props => [
    step,
    getStarted,
    baseProfileStateData,
    keychainStateData,
    walletLinkStateData,
    registrationStateData,
    recoverStateData,
    walletDrepLinkAccountDetails,
  ];

  RegistrationState copyWith({
    RegistrationStep? step,
    RegistrationGetStartedState? getStarted,
    BaseProfileStateData? baseProfileStateData,
    KeychainStateData? keychainStateData,
    WalletLinkStateData? walletLinkStateData,
    RegistrationStateData? registrationStateData,
    RecoverStateData? recoverStateData,
    Optional<Result<AccountSummaryData, LocalizedException>>? walletDrepLinkAccountDetails,
  }) {
    return RegistrationState(
      step: step ?? this.step,
      getStarted: getStarted ?? this.getStarted,
      baseProfileStateData: baseProfileStateData ?? this.baseProfileStateData,
      keychainStateData: keychainStateData ?? this.keychainStateData,
      walletLinkStateData: walletLinkStateData ?? this.walletLinkStateData,
      registrationStateData: registrationStateData ?? this.registrationStateData,
      recoverStateData: recoverStateData ?? this.recoverStateData,
      walletDrepLinkAccountDetails: walletDrepLinkAccountDetails.dataOr(
        this.walletDrepLinkAccountDetails,
      ),
    );
  }
}
