import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/base_profile_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/keychain_creation_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/recover_cubit.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/wallet_link_cubit.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('RegistrationCubit');

/// Manages the registration state.
final class RegistrationCubit extends Cubit<RegistrationState>
    with BlocErrorEmitterMixin {
  final BaseProfileCubit _baseProfileCubit;
  final KeychainCreationCubit _keychainCreationCubit;
  final WalletLinkCubit _walletLinkCubit;
  final RecoverCubit _recoverCubit;

  final UserService _userService;
  final RegistrationService _registrationService;
  final RegistrationProgressNotifier _progressNotifier;

  Bip32Ed25519XPrivateKey? _masterKey;
  Transaction? _transaction;

  /// Returns [RegistrationCubit] if found in widget tree. Does not add
  /// rebuild dependency when called.
  static RegistrationCubit of(BuildContext context) {
    return context.read<RegistrationCubit>();
  }

  RegistrationCubit({
    required Downloader downloader,
    required UserService userService,
    required RegistrationService registrationService,
    required RegistrationProgressNotifier progressNotifier,
  })  : _registrationService = registrationService,
        _userService = userService,
        _progressNotifier = progressNotifier,
        _baseProfileCubit = BaseProfileCubit(),
        _keychainCreationCubit = KeychainCreationCubit(
          downloader: downloader,
        ),
        _walletLinkCubit = WalletLinkCubit(
          registrationService: registrationService,
        ),
        _recoverCubit = RecoverCubit(
          userService: userService,
          registrationService: registrationService,
        ),
        super(const RegistrationState()) {
    _baseProfileCubit.stream.listen(_onBaseProfileStateDataChanged);
    _keychainCreationCubit.stream.listen(_onKeychainStateDataChanged);
    _walletLinkCubit.stream.listen(_onWalletLinkStateDataChanged);
    _recoverCubit.stream.listen(_onRecoverStateDataChanged);

    _baseProfileCubit.errorStream.listen(emitError);
    _keychainCreationCubit.errorStream.listen(emitError);
    _walletLinkCubit.errorStream.listen(emitError);
    _recoverCubit.errorStream.listen(emitError);

    // Emits initialization state
    emit(
      state.copyWith(
        baseProfileStateData: _baseProfileCubit.state,
        keychainStateData: _keychainCreationCubit.state,
        walletLinkStateData: _walletLinkCubit.state,
        recoverStateData: _recoverCubit.state,
      ),
    );
  }

  BaseProfileManager get baseProfile => _baseProfileCubit;

  KeychainCreationManager get keychainCreation => _keychainCreationCubit;

  WalletLinkManager get walletLink => _walletLinkCubit;

  RecoverManager get recover => _recoverCubit;

  bool get hasProgress => !_progressNotifier.value.isEmpty;

  RegistrationStateData get _registrationState => state.registrationStateData;

  @override
  Future<void> close() {
    _baseProfileCubit.close();
    _keychainCreationCubit.close();
    _walletLinkCubit.close();
    _recoverCubit.close();
    return super.close();
  }

  void goToStep(RegistrationStep step) {
    _goToStep(step);
  }

  void recoverProgress() {
    final progress = _progressNotifier.value;
    final baseProfileProgress = progress.baseProfileProgress;
    final keychainProgress = progress.keychainProgress;

    if (baseProfileProgress != null) {
      _baseProfileCubit
        ..updateDisplayName(DisplayName.dirty(baseProfileProgress.displayName))
        ..updateEmail(Email.dirty(baseProfileProgress.email))
        ..updateToS(isAccepted: true)
        ..updatePrivacyPolicy(isAccepted: true)
        ..updateDataUsage(isAccepted: true);
    }

    if (keychainProgress != null) {
      _keychainCreationCubit
        ..recoverSeedPhrase(keychainProgress.seedPhrase)
        ..recoverPassword(keychainProgress.password);
    }

    final step = AccountCreateProgressStep(
      completedSteps: [
        if (baseProfileProgress != null) AccountCreateStepType.baseProfile,
        if (keychainProgress != null) AccountCreateStepType.keychain,
      ],
    );
    _goToStep(step);
  }

  void createNewAccount() {
    _progressNotifier.clear();

    final nextStep = _nextStep(from: const CreateBaseProfileStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  void recoverKeychain() {
    _progressNotifier.clear();

    unawaited(recover.checkLocalKeychains());

    _goToStep(const RecoverMethodStep());
  }

  void recoverWithSeedPhrase() {
    final nextStep = _nextStep(from: const RecoverWithSeedPhraseStep());
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
    if (nextStep is AccountCreateProgressStep) {
      if (nextStep.completedSteps.isNotEmpty) {
        _saveRegistrationProgress(nextStep.completedSteps.last);
      }
    }
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
          canSubmitTx: Optional.of(Success(false)),
          transactionFee: const Optional.empty(),
          isSubmittingTx: false,
          account: const Optional.empty(),
        ),
      );

      final seedPhrase = _keychainCreationCubit.seedPhrase!;
      final wallet = _walletLinkCubit.selectedWallet!;
      final roles = _walletLinkCubit.roles;

      final masterKey =
          await _registrationService.deriveMasterKey(seedPhrase: seedPhrase);

      final transaction = await _registrationService.prepareRegistration(
        wallet: wallet,
        // TODO(dtscalac): inject the networkId
        networkId: NetworkId.testnet,
        masterKey: masterKey,
        roles: roles,
      );

      _masterKey = masterKey;
      _transaction = transaction;

      final fee = transaction.body.fee;

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          canSubmitTx: Optional.of(Success(true)),
          transactionFee: Optional.of(
            CryptocurrencyFormatter.formatExactAmount(fee),
          ),
        ),
      );
    } on RegistrationException catch (error, stackTrace) {
      _logger.severe('Prepare registration', error, stackTrace);

      _masterKey?.drop();
      _masterKey = null;
      _transaction = null;

      final exception = LocalizedRegistrationException.from(error);

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          canSubmitTx: Optional.of(Failure(exception)),
          transactionFee: const Optional.empty(),
        ),
      );
    }
  }

  Future<void> submitRegistration() async {
    try {
      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          account: const Optional.empty(),
          isSubmittingTx: true,
        ),
      );

      final displayName = _baseProfileCubit.state.displayName;
      final email = _baseProfileCubit.state.email;

      final masterKey = _masterKey!;
      final transaction = _transaction!;

      final password = _keychainCreationCubit.password;
      final lockFactor = PasswordLockFactor(password.value);

      final wallet = _walletLinkCubit.selectedWallet!;
      final roles = _walletLinkCubit.roles;

      final account = await _registrationService.register(
        displayName: displayName.value,
        email: email.value,
        wallet: wallet,
        unsignedTx: transaction,
        roles: roles,
        lockFactor: lockFactor,
        masterKey: masterKey,
      );

      await _userService.useAccount(account);

      _progressNotifier.clear();

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          account: Optional(Success(account)),
          isSubmittingTx: false,
        ),
      );

      nextStep();
    } on RegistrationException catch (error, stackTrace) {
      _logger.severe('Submit registration', error, stackTrace);

      final exception = LocalizedRegistrationException.from(error);

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          account: Optional(Failure(exception)),
          isSubmittingTx: false,
        ),
      );
    }
  }

  void _saveRegistrationProgress(AccountCreateStepType stepType) {
    switch (stepType) {
      case AccountCreateStepType.baseProfile:
        final data = _baseProfileCubit.createRecoverProgress();
        _progressNotifier.value = _progressNotifier.value.copyWith(
          baseProfileProgress: Optional(data),
          keychainProgress: const Optional.empty(),
        );
      case AccountCreateStepType.keychain:
        final data = _keychainCreationCubit.createRecoverProgress();
        _progressNotifier.value = _progressNotifier.value.copyWith(
          keychainProgress: Optional(data),
        );
      case AccountCreateStepType.walletLink:
      // no-op
    }
  }

  // TODO(damian-molinski): Try refactoring nested function to be generic.
  RegistrationStep? _nextStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    RegistrationStep nextBaseProfile() {
      final step = state.step;

      // if current step is not from create base profile just return current one
      if (step is! CreateBaseProfileStep) {
        return const CreateBaseProfileStep();
      }

      final nextStage = step.stage.next;
      return nextStage != null
          ? CreateBaseProfileStep(stage: nextStage)
          : const AccountCreateProgressStep(
              completedSteps: [
                AccountCreateStepType.baseProfile,
              ],
            );
    }

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
          : const AccountCreateProgressStep(
              completedSteps: [
                AccountCreateStepType.baseProfile,
                AccountCreateStepType.keychain,
              ],
            );
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
      if (step is! RecoverWithSeedPhraseStep) {
        return const RecoverWithSeedPhraseStep();
      }

      final nextStage = step.stage.next;
      return nextStage != null
          ? RecoverWithSeedPhraseStep(stage: nextStage)
          : null;
    }

    RegistrationStep? nextRegistrationStep(
      List<AccountCreateStepType> completedSteps,
    ) {
      if (!completedSteps.contains(AccountCreateStepType.baseProfile)) {
        return const CreateBaseProfileStep();
      }

      if (!completedSteps.contains(AccountCreateStepType.keychain)) {
        return const CreateKeychainStep();
      }

      if (!completedSteps.contains(AccountCreateStepType.walletLink)) {
        return const WalletLinkStep();
      }

      return null;
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverMethodStep() => null,
      RecoverWithSeedPhraseStep() => nextRecoverWithSeedPhraseStep(),
      CreateBaseProfileStep() => nextBaseProfile(),
      CreateKeychainStep() => nextKeychainStep(),
      AccountCreateProgressStep(:final completedSteps) =>
        nextRegistrationStep(completedSteps),
      WalletLinkStep() => nextWalletLinkStep(),
      AccountCompletedStep() => null,
    };
  }

  RegistrationStep? _previousStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    /// Nested function. Responsible only for base profile steps logic.
    RegistrationStep previousBaseProfileStep() {
      final step = state.step;

      final previousStep =
          step is CreateBaseProfileStep ? step.stage.previous : null;

      return previousStep != null
          ? CreateBaseProfileStep(stage: previousStep)
          : const GetStartedStep();
    }

    /// Nested function. Responsible only for keychain steps logic.
    RegistrationStep previousKeychainStep() {
      final step = state.step;

      final previousStep =
          step is CreateKeychainStep ? step.stage.previous : null;

      return previousStep != null
          ? CreateKeychainStep(stage: previousStep)
          : const AccountCreateProgressStep(
              completedSteps: [
                AccountCreateStepType.baseProfile,
              ],
            );
    }

    /// Nested function. Responsible only for wallet link steps logic.
    RegistrationStep previousWalletLinkStep() {
      final step = state.step;

      final previousStep = step is WalletLinkStep ? step.stage.previous : null;

      return previousStep != null
          ? WalletLinkStep(stage: previousStep)
          : const AccountCreateProgressStep(
              completedSteps: [
                AccountCreateStepType.baseProfile,
                AccountCreateStepType.keychain,
              ],
            );
    }

    RegistrationStep previousRecoverWithSeedPhraseStep() {
      final step = state.step;

      final previousStep =
          step is RecoverWithSeedPhraseStep ? step.stage.previous : null;

      return previousStep != null
          ? RecoverWithSeedPhraseStep(stage: previousStep)
          : const RecoverMethodStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      RecoverMethodStep() => const GetStartedStep(),
      RecoverWithSeedPhraseStep() => previousRecoverWithSeedPhraseStep(),
      CreateBaseProfileStep() => previousBaseProfileStep(),
      CreateKeychainStep() => previousKeychainStep(),
      AccountCreateProgressStep() => null,
      WalletLinkStep() => previousWalletLinkStep(),
      AccountCompletedStep() => null,
    };
  }

  void _goToStep(RegistrationStep step) {
    emit(state.copyWith(step: step));
  }

  void _onBaseProfileStateDataChanged(BaseProfileStateData data) {
    emit(state.copyWith(baseProfileStateData: data));
  }

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
