import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
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
  final BlockchainConfig _blockchainConfig;

  CatalystId? _accountId;
  Keychain? _keychain;
  Transaction? _transaction;

  RegistrationCubit({
    required DownloaderService downloaderService,
    required UserService userService,
    required RegistrationService registrationService,
    required KeyDerivationService keyDerivationService,
    required RegistrationProgressNotifier progressNotifier,
    required BlockchainConfig blockchainConfig,
  })  : _userService = userService,
        _registrationService = registrationService,
        _progressNotifier = progressNotifier,
        _blockchainConfig = blockchainConfig,
        _baseProfileCubit = BaseProfileCubit(),
        _keychainCreationCubit = KeychainCreationCubit(
          downloaderService: downloaderService,
        ),
        _walletLinkCubit = WalletLinkCubit(
          registrationService: registrationService,
        ),
        _recoverCubit = RecoverCubit(
          userService: userService,
          registrationService: registrationService,
          keyDerivationService: keyDerivationService,
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

  RecoverManager get recover => _recoverCubit;

  WalletLinkManager get walletLink => _walletLinkCubit;

  RegistrationStateData get _registrationState => state.registrationStateData;

  void changeRoleSetup() {
    _goToStep(const WalletLinkStep(stage: WalletLinkStage.rolesChooser));
  }

  void chooseOtherWallet() {
    _goToStep(const WalletLinkStep(stage: WalletLinkStage.selectWallet));
  }

  @override
  Future<void> close() {
    _baseProfileCubit.close();
    _keychainCreationCubit.close();
    _walletLinkCubit.close();
    _recoverCubit.close();
    return super.close();
  }

  Future<void> createKeychain() async {
    final seedPhrase = _keychainCreationCubit.seedPhrase;
    final password = _keychainCreationCubit.password;

    if (seedPhrase == null) {
      emitError(const LocalizedRegistrationSeedPhraseNotFoundException());
      return;
    }
    if (password.isNotValid) {
      emitError(const LocalizedRegistrationUnlockPasswordNotFoundException());
      return;
    }

    final lockFactor = PasswordLockFactor(password.value);

    _keychain = await _registrationService.createKeychain(
      seedPhrase: seedPhrase,
      lockFactor: lockFactor,
    );

    nextStep();
  }

  void createNewAccount() {
    _progressNotifier.clear();

    final nextStep = _nextStep(from: const CreateBaseProfileStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  Future<void> finishRegistration() async {
    try {
      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          account: const Optional.empty(),
          isSubmittingTx: true,
        ),
      );

      final submitData = _buildAccountSubmitData();

      switch (submitData) {
        case AccountSubmitFullData():
          final account = await _registrationService.register(data: submitData);

          await _userService.useAccount(account);
        case AccountSubmitUpdateData(
            :final metadata,
            :final accountId,
            :final roles,
          ):
          await _registrationService.submitTransaction(
            wallet: metadata.wallet,
            unsignedTx: metadata.transaction,
          );

          await _userService.updateAccount(id: accountId, roles: roles);
      }

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          account: Optional(Success(true)),
          isSubmittingTx: false,
        ),
      );

      nextStep();
    } on RegistrationException catch (error, stack) {
      _logger.severe('Submit registration', error, stack);

      final exception = LocalizedRegistrationException.from(error);

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          account: Optional(Failure(exception)),
          isSubmittingTx: false,
        ),
      );
    } catch (error, stack) {
      _logger.severe('Submit registration', error, stack);

      const exception = LocalizedRegistrationUnknownException();

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          account: Optional(Failure(exception)),
          isSubmittingTx: false,
        ),
      );
    }
  }

  void goToStep(RegistrationStep step) {
    _goToStep(step);
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

      final accountId = _accountId;
      final masterKey = await _keychain?.getMasterKey();
      if (masterKey == null) {
        emitError(const LocalizedRegistrationKeychainNotFoundException());
        return;
      }

      final wallet = _walletLinkCubit.selectedWallet!;
      final roles = _walletLinkCubit.roles;
      final accountRoles = <AccountRole>{};

      if (accountId != null) {
        final account = _userService.user.getAccount(accountId);
        accountRoles.addAll(account.roles);
      }

      final transactionRoles = AccountRole.values.map((role) {
        final isSelected = roles.contains(role);
        final isAccountRole = accountRoles.contains(role);

        if (isSelected && !isAccountRole) {
          return RegistrationTransactionRole.set(role);
        }

        if (!isSelected && isAccountRole) {
          return RegistrationTransactionRole.unset(role);
        }

        return RegistrationTransactionRole.undefined(role);
      }).toSet();

      final transaction = await _registrationService.prepareRegistration(
        wallet: wallet,
        networkId: _blockchainConfig.networkId,
        masterKey: masterKey,
        roles: transactionRoles,
      );

      _transaction = transaction;

      final fee = transaction.body.fee;
      final formattedFree = CryptocurrencyFormatter.formatExactAmount(fee);

      _onRegistrationStateDataChanged(
        _registrationState.copyWith(
          canSubmitTx: Optional.of(Success(true)),
          transactionFee: Optional.of(formattedFree),
        ),
      );
    } on RegistrationException catch (error, stackTrace) {
      _logger.severe('Prepare registration', error, stackTrace);

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

  void previousStep() {
    final previousStep = _previousStep();
    if (previousStep != null) {
      _goToStep(previousStep);
    }
  }

  void recoverKeychain() {
    _progressNotifier.clear();

    unawaited(recover.checkLocalKeychains());

    _goToStep(const RecoverMethodStep());
  }

  void recoverProgress() {
    final progress = _progressNotifier.value;
    final baseProfileProgress = progress.baseProfileProgress;
    final keychainProgress = progress.keychainProgress;

    if (baseProfileProgress != null) {
      _baseProfileCubit
        ..updateUsername(Username.dirty(baseProfileProgress.username))
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

  void recoverWithSeedPhrase() {
    final nextStep = _nextStep(from: const RecoverWithSeedPhraseStep());
    if (nextStep != null) {
      _goToStep(nextStep);
    }
  }

  Future<void> startAccountUpdate({
    required CatalystId id,
  }) async {
    final user = _userService.user;
    if (!user.hasAccount(id: id)) {
      return;
    }

    final account = user.getAccount(id);

    _accountId = id;
    _keychain = account.keychain;

    _walletLinkCubit.setAccountRoles(account.roles);

    _goToStep(const WalletLinkStep());
  }

  AccountSubmitData _buildAccountSubmitData() {
    final keychain = _keychain!;
    final wallet = _walletLinkCubit.selectedWallet!;
    final transaction = _transaction!;

    final metadata = AccountSubmitMetadata(
      wallet: wallet,
      transaction: transaction,
    );

    final roles = _walletLinkCubit.roles;

    final accountId = _accountId;
    if (accountId != null) {
      return AccountSubmitUpdateData(
        metadata: metadata,
        accountId: accountId,
        roles: roles,
      );
    }

    final username = _baseProfileCubit.state.username.value;
    final email = _baseProfileCubit.state.email.value;

    return AccountSubmitFullData(
      metadata: metadata,
      keychain: keychain,
      username: username,
      email: email,
      roles: roles,
    );
  }

  void _goToStep(RegistrationStep step) {
    emit(state.copyWith(step: step));
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

  void _onBaseProfileStateDataChanged(BaseProfileStateData data) {
    emit(state.copyWith(baseProfileStateData: data));
  }

  void _onKeychainStateDataChanged(KeychainStateData data) {
    emit(state.copyWith(keychainStateData: data));
  }

  void _onRecoverStateDataChanged(RecoverStateData data) {
    emit(state.copyWith(recoverStateData: data));
  }

  void _onRegistrationStateDataChanged(RegistrationStateData data) {
    emit(state.copyWith(registrationStateData: data));
  }

  void _onWalletLinkStateDataChanged(WalletLinkStateData data) {
    emit(state.copyWith(walletLinkStateData: data));
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

  /// Returns [RegistrationCubit] if found in widget tree. Does not add
  /// rebuild dependency when called.
  static RegistrationCubit of(BuildContext context) {
    return context.read<RegistrationCubit>();
  }
}
