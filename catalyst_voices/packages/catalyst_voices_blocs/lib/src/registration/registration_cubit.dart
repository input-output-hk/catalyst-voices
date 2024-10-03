import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/keychain_creation_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/wallet_link_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the registration state.
final class RegistrationCubit extends Cubit<RegistrationState> {
  final KeychainCreationCubit _keychainCreationCubit;
  final WalletLinkCubit _walletLinkCubit;

  RegistrationCubit({
    required Downloader downloader,
  })  : _keychainCreationCubit = KeychainCreationCubit(
          downloader: downloader,
        ),
        _walletLinkCubit = WalletLinkCubit(),
        super(const GetStarted()) {
    _keychainCreationCubit.stream.listen(emit);
    _walletLinkCubit.stream.listen(emit);
  }

  /// Returns [RegistrationCubit] if found in widget tree. Does not add
  /// rebuild dependency when called.
  static RegistrationCubit of(BuildContext context) {
    return context.read<RegistrationCubit>();
  }

  /// Returns [RegistrationCubit] if found in widget tree. Adds rebuild
  /// dependency when called so you can not call it in initState.
  static RegistrationCubit watch(BuildContext context) {
    return context.watch<RegistrationCubit>();
  }

  @override
  Future<void> close() {
    _keychainCreationCubit.close();
    _walletLinkCubit.close();
    return super.close();
  }

  void createNewKeychainStep() {
    final nextStep = _nextStep(from: const CreateKeychainStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void recoverKeychainStep() {
    final nextStep = _nextStep(from: const RecoverStep());
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

  void buildSeedPhrase({
    bool forceRefresh = false,
  }) {
    if (forceRefresh) {
      _keychainCreationCubit.buildSeedPhrase();
    } else {
      _keychainCreationCubit.ensureSeedPhraseCreated();
    }
  }

  void confirmSeedPhraseStored({
    required bool confirmed,
  }) {
    _keychainCreationCubit.setSeedPhraseStoredConfirmed(confirmed);
  }

  Future<void> downloadSeedPhrase() {
    return _keychainCreationCubit.downloadSeedPhrase();
  }

  void setSeedPhraseCheckConfirmed({
    required bool isConfirmed,
  }) {
    _keychainCreationCubit.setSeedPhraseCheckConfirmed(
      isConfirmed: isConfirmed,
    );
  }

  void setPassword(String newValue) {
    _keychainCreationCubit.setPassword(newValue);
  }

  void setConfirmPassword(String newValue) {
    _keychainCreationCubit.setConfirmPassword(newValue);
  }

  Future<void> createKeychain() => _keychainCreationCubit.createKeychain();

  void refreshWallets() {
    unawaited(_walletLinkCubit.refreshWallets());
  }

  Future<void> selectWallet(CardanoWallet wallet) {
    return _walletLinkCubit.selectWallet(wallet);
  }

  void selectRoles(Set<AccountRole> roles) {
    _walletLinkCubit.selectRoles(roles);
  }

  void submitRegistration() {
    // TODO(dtscalac): submit RBAC transaction
  }

  RegistrationStep? _nextStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    RegistrationStep nextKeychainStep() {
      // if current step is not from create keychain just return current one
      if (state.step is! CreateKeychainStep) {
        return _keychainCreationCubit.state.step;
      }

      final nextStep = _keychainCreationCubit.nextStep();

      // if there is no next step from keychain creation go to finish account.
      return nextStep ?? const FinishAccountCreationStep();
    }

    RegistrationStep nextWalletLinkStep() {
      // if current step is not from create WalletLink just return current one
      if (state.step is! WalletLinkStep) {
        return _walletLinkCubit.state.step;
      }

      final nextStep = _walletLinkCubit.nextStep();

      // if there is no next step from wallet link go to account completed.
      return nextStep ?? const AccountCompletedStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverStep() => throw UnimplementedError(),
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
      final previousStep = _keychainCreationCubit.previousStep();

      // if is at first step of keychain creation go to get started.
      return previousStep ?? const GetStartedStep();
    }

    /// Nested function. Responsible only for wallet link steps logic.
    RegistrationStep previousWalletLinkStep() {
      final previousStep = _walletLinkCubit.previousStep();

      // if is at first step of wallet link go to finish account.
      return previousStep ?? const FinishAccountCreationStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverStep() => throw UnimplementedError(),
      CreateKeychainStep() => previousKeychainStep(),
      FinishAccountCreationStep() => null,
      WalletLinkStep() => previousWalletLinkStep(),
      AccountCompletedStep() => null,
    };
  }

  void _goToStep(RegistrationStep step) {
    if (step is CreateKeychainStep) {
      _keychainCreationCubit.changeStage(step.stage);
      emit(_keychainCreationCubit.state);
    } else if (step is WalletLinkStep) {
      _walletLinkCubit.changeStage(step.stage);
      emit(_walletLinkCubit.state);
    } else {
      emit(_buildState(step: step));
    }
  }

  RegistrationState _buildState({
    RegistrationStep? step,
  }) {
    step ??= state.step;

    return switch (step) {
      GetStartedStep() => const GetStarted(),
      FinishAccountCreationStep() => const FinishAccountCreation(),
      RecoverStep() => const Recover(),
      CreateKeychainStep() => _keychainCreationCubit.state,
      WalletLinkStep() => _walletLinkCubit.state,
      AccountCompletedStep() => const AccountCompleted(),
    };
  }
}
