import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/keychain_creation_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/recover_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/wallet_link_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/state_data/keychain_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('RegistrationCubit');

/// Manages the registration state.
final class RegistrationCubit extends Cubit<RegistrationState> {
  final KeychainCreationCubit _keychainCreationCubit;
  final WalletLinkCubit _walletLinkCubit;
  final RecoverCubit _recoverCubit;
  final RegistrationService registrationService;

  RegistrationCubit({
    required Downloader downloader,
    required this.registrationService,
  })  : _keychainCreationCubit = KeychainCreationCubit(
          downloader: downloader,
        ),
        _walletLinkCubit = WalletLinkCubit(
          registrationService: registrationService,
        ),
        _recoverCubit = RecoverCubit(),
        super(const RegistrationState()) {
    _keychainCreationCubit.stream.listen(_onKeychainStateDataChanged);
    _walletLinkCubit.stream.listen(_onWalletLinkStateDataChanged);
    _recoverCubit.stream.listen(_onRecoverStateDataChanged);

    // Emits initialization state
    emit(
      state.copyWith(
        keychainStateData: _keychainCreationCubit.state,
        walletLinkStateData: _walletLinkCubit.state,
        recoverStateData: _recoverCubit.state,
      ),
    );
  }

  KeychainCreationManager get keychainCreation => _keychainCreationCubit;

  WalletLinkManager get walletLink => _walletLinkCubit;

  RecoverManager get recover => _recoverCubit;

  /// Returns [RegistrationCubit] if found in widget tree. Does not add
  /// rebuild dependency when called.
  static RegistrationCubit of(BuildContext context) {
    return context.read<RegistrationCubit>();
  }

  @override
  Future<void> close() {
    _keychainCreationCubit.close();
    _walletLinkCubit.close();
    return super.close();
  }

  void createNewKeychain() {
    final nextStep = _nextStep(from: const CreateKeychainStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void recoverKeychain() {
    unawaited(recover.checkLocalKeychains());

    _goToStep(const RecoverMethodStep());
  }

  void recoverWithSeedPhrase() {
    final nextStep = _nextStep(from: const SeedPhraseRecoverStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void chooseOtherWallet() {
    _goToStep(const WalletLinkStep(stage: WalletLinkStage.selectWallet));
  }

  void changeRoleSetup() {
    _goToStep(const WalletLinkStep(stage: WalletLinkStage.rolesChooser));
  }

  void nextStep() {
    final nextStep = _nextStep();
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void previousStep() {
    final previousStep = _previousStep();
    if (previousStep != null) {
      _goToStep(previousStep);
    }
  }

  Future<void> prepareRegistration() async {
    try {
      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          unsignedTx: const Optional(null),
          submittedTx: const Optional(null),
          isSubmittingTx: false,
        ),
      );

      final unsignedTx = await registrationService.prepareRegistration(
        wallet: _walletLinkState.selectedCardanoWallet!,
        // TODO(dtscalac): inject the networkId
        networkId: NetworkId.testnet,
        seedPhrase: _keychainState.seedPhrase!,
        roles: _walletLinkState.selectedRoles ?? _walletLinkState.defaultRoles,
      );

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          unsignedTx: Optional(Success(unsignedTx)),
        ),
      );
    } on RegistrationException catch (error, stackTrace) {
      _logger.severe('prepareRegistration', error, stackTrace);
      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          unsignedTx: Optional(
            Failure(LocalizedRegistrationException.from(error)),
          ),
        ),
      );
    }
  }

  Future<void> submitRegistration() async {
    try {
      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          submittedTx: const Optional(null),
          isSubmittingTx: true,
        ),
      );

      final signedTx = await registrationService.submitRegistration(
        wallet: _walletLinkState.selectedCardanoWallet!,
        unsignedTx: _registrationState.unsignedTx!.success,
      );

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          submittedTx: Optional(Success(signedTx)),
          isSubmittingTx: false,
        ),
      );
      nextStep();
    } on RegistrationException catch (error, stackTrace) {
      _logger.severe('submitRegistration', error, stackTrace);
      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          submittedTx: Optional(
            Failure(LocalizedRegistrationException.from(error)),
          ),
          isSubmittingTx: false,
        ),
      );
    }
  }

  RegistrationStep? _nextStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    RegistrationStep nextKeychainStep() {
      final step = state.step;

      // if current step is not from create keychain just return current one
      if (step is! CreateKeychainStep) {
        return const CreateKeychainStep();
      }

      // if there is no next step from keychain creation go to finish account.
      final nextStage = step.stage.next;
      return nextStage != null
          ? CreateKeychainStep(stage: nextStage)
          : const FinishAccountCreationStep();
    }

    RegistrationStep nextWalletLinkStep() {
      final step = state.step;

      // if current step is not from create WalletLink just return current one
      if (step is! WalletLinkStep) {
        return const WalletLinkStep();
      }

      // if there is no next step from wallet link go to account completed.
      final nextStage = step.stage.next;
      return nextStage != null
          ? WalletLinkStep(stage: nextStage)
          : const AccountCompletedStep();
    }

    RegistrationStep? nextRecoverWithSeedPhraseStep() {
      final step = state.step;

      // if current step is not from create SeedPhraseRecoverStep
      // just return current one
      if (step is! SeedPhraseRecoverStep) {
        return const SeedPhraseRecoverStep();
      }

      final nextStage = step.stage.next;

      return nextStage != null ? SeedPhraseRecoverStep(stage: nextStage) : null;
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverMethodStep() => null,
      SeedPhraseRecoverStep() => nextRecoverWithSeedPhraseStep(),
      CreateKeychainStep() => nextKeychainStep(),
      FinishAccountCreationStep() => const WalletLinkStep(),
      WalletLinkStep() => nextWalletLinkStep(),
      AccountCompletedStep() => null,
    };
  }

  RegistrationStep? _previousStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    /// Nested function. Responsible only for keychain steps logic.
    RegistrationStep previousKeychainStep() {
      final step = state.step;

      final previousStep =
          step is CreateKeychainStep ? step.stage.previous : null;

      return previousStep != null
          ? CreateKeychainStep(stage: previousStep)
          : const GetStartedStep();
    }

    /// Nested function. Responsible only for wallet link steps logic.
    RegistrationStep previousWalletLinkStep() {
      final step = state.step;

      final previousStep = step is WalletLinkStep ? step.stage.previous : null;

      return previousStep != null
          ? WalletLinkStep(stage: previousStep)
          : const FinishAccountCreationStep();
    }

    RegistrationStep previousRecoverWithSeedPhraseStep() {
      final step = state.step;

      final previousStep =
          step is SeedPhraseRecoverStep ? step.stage.previous : null;

      return previousStep != null
          ? SeedPhraseRecoverStep(stage: previousStep)
          : const RecoverMethodStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverMethodStep() => const GetStartedStep(),
      SeedPhraseRecoverStep() => previousRecoverWithSeedPhraseStep(),
      CreateKeychainStep() => previousKeychainStep(),
      FinishAccountCreationStep() => null,
      WalletLinkStep() => previousWalletLinkStep(),
      AccountCompletedStep() => null,
    };
  }

  void _goToStep(RegistrationStep step) {
    emit(state.copyWith(step: step));
  }

  KeychainStateData get _keychainState => state.keychainStateData;

  WalletLinkStateData get _walletLinkState => state.walletLinkStateData;

  RegistrationStateData get _registrationState => state.registrationStateData;

  void _onKeychainStateDataChanged(KeychainStateData data) {
    emit(state.copyWith(keychainStateData: data));
  }

  void _onWalletLinkStateDataChanged(WalletLinkStateData data) {
    emit(state.copyWith(walletLinkStateData: data));
  }

  void _onRegistrationStateDataChanged(RegistrationStateData data) {
    emit(state.copyWith(registrationStateData: data));
  }

  void _onRecoverStateDataChanged(RecoverStateData data) {
    emit(state.copyWith(recoverStateData: data));
  }
}
