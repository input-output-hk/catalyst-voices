// ignore_for_file: one_member_abstracts

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/unlock_password_manager.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('RecoverCubit');

abstract interface class RecoverManager implements UnlockPasswordManager {
  Future<void> checkLocalKeychains();

  void setSeedPhraseWords(List<SeedPhraseWord> words);

  Future<void> recoverAccount();

  Future<bool> createKeychain();
}

final class RecoverCubit extends Cubit<RecoverStateData>
    with BlocErrorEmitterMixin, UnlockPasswordMixin
    implements RecoverManager {
  final RegistrationService _registrationService;

  SeedPhrase? _seedPhrase;
  Keychain? _keychain;

  RecoverCubit({
    required RegistrationService registrationService,
  })  : _registrationService = registrationService,
        super(const RecoverStateData()) {
    /// pre-populate all available words
    emit(state.copyWith(seedPhraseWords: SeedPhrase.wordList));

    if (kDebugMode) {
      setSeedPhraseWords(_testWords);
    }
  }

  // Note. this function will have more sense when we'll implement
  // multi account feature. Then we can have multiple keychains and lookup
  // those already stored locally.
  @override
  Future<void> checkLocalKeychains() async {
    // TODO(damian-molinski): to be implemented
  }

  @override
  void setSeedPhraseWords(List<SeedPhraseWord> words) {
    final isValid = SeedPhrase.isValid(words: words);
    if (isValid) {
      _seedPhrase = SeedPhrase.fromWords(words);
    }

    emit(
      state.copyWith(
        userSeedPhraseWords: words,
        isSeedPhraseValid: isValid,
      ),
    );
  }

  @override
  Future<void> recoverAccount() async {
    try {
      emit(state.copyWith(accountDetails: const Optional.empty()));

      final seedPhrase = _seedPhrase;
      final keychain = _keychain;

      if (seedPhrase == null || keychain == null) {
        const exception = LocalizedRegistrationSeedPhraseNotFoundException();
        emit(state.copyWith(accountDetails: Optional(Failure(exception))));
        return;
      }

      final data = await _registrationService.recoverAccount(seedPhrase);

      final walletInfo = data.walletInfo;
      final profile = data.profile;

      await keychain.setProfile(profile);

      final accountDetails = AccountSummaryData(
        walletConnection: WalletConnectionData(
          name: walletInfo.metadata.name,
          icon: walletInfo.metadata.icon,
        ),
        walletSummary: WalletSummaryData(
          balance: CryptocurrencyFormatter.formatAmount(walletInfo.balance),
          address: WalletAddressFormatter.formatShort(walletInfo.address),
          clipboardAddress: walletInfo.address.toBech32(),
          showLowBalance: false,
        ),
      );

      emit(state.copyWith(accountDetails: Optional(Success(accountDetails))));
    } on RegistrationException catch (error, stack) {
      _logger.severe('recover account', error, stack);

      final exception = LocalizedRegistrationException.from(error);
      emit(state.copyWith(accountDetails: Optional(Failure(exception))));
    } catch (error, stack) {
      _logger.severe('recover account', error, stack);

      const exception = LocalizedUnknownException();
      emit(state.copyWith(accountDetails: Optional(Failure(exception))));
    }
  }

  @override
  Future<bool> createKeychain() async {
    try {
      final seedPhrase = _seedPhrase;
      final password = this.password;

      if (seedPhrase == null) {
        throw const LocalizedRegistrationSeedPhraseNotFoundException();
      }
      if (password.isNotValid) {
        throw const LocalizedRegistrationUnlockPasswordNotFoundException();
      }

      final lockFactor = PasswordLockFactor(password.value);
      final keychain = await _registrationService.createKeychain(
        seedPhrase: seedPhrase,
        lockFactor: lockFactor,
      );
      await keychain.unlock(lockFactor);

      _keychain = keychain;

      return true;
    } catch (error, stack) {
      _logger.severe('Create keychain', error, stack);

      _keychain = null;

      emitError(error);

      return false;
    }
  }

  @override
  void onUnlockPasswordStateChanged(UnlockPasswordState data) {
    emit(state.copyWith(unlockPasswordState: data));
  }
}

const _testWords = [
  SeedPhraseWord('broken', nr: 1),
  SeedPhraseWord('member', nr: 2),
  SeedPhraseWord('repeat', nr: 3),
  SeedPhraseWord('liquid', nr: 4),
  SeedPhraseWord('barely', nr: 5),
  SeedPhraseWord('electric', nr: 6),
  SeedPhraseWord('theory', nr: 7),
  SeedPhraseWord('paddle', nr: 8),
  SeedPhraseWord('coyote', nr: 9),
  SeedPhraseWord('behind', nr: 10),
  SeedPhraseWord('unique', nr: 11),
  SeedPhraseWord('member', nr: 12),
];
