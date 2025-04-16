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

final _logger = Logger('RecoverCubit');

final class RecoverCubit extends Cubit<RecoverStateData>
    with BlocErrorEmitterMixin, UnlockPasswordMixin
    implements RecoverManager {
  final UserService _userService;
  final RegistrationService _registrationService;
  final KeyDerivationService _keyDerivationService;

  SeedPhrase? _seedPhrase;
  Account? _recoveredAccount;

  RecoverCubit({
    required UserService userService,
    required RegistrationService registrationService,
    required KeyDerivationService keyDerivationService,
  })  : _userService = userService,
        _registrationService = registrationService,
        _keyDerivationService = keyDerivationService,
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
  void onUnlockPasswordStateChanged(UnlockPasswordState data) {
    emit(state.copyWith(unlockPasswordState: data));
  }

  @override
  Future<bool> recoverAccount() async {
    try {
      emit(state.copyWith(accountDetails: const Optional.empty()));

      final seedPhrase = _seedPhrase;
      if (seedPhrase == null) {
        const exception = LocalizedRegistrationSeedPhraseNotFoundException();
        emit(state.copyWith(accountDetails: Optional(Failure(exception))));
        return false;
      }

      final account = await _registrationService.recoverAccount(
        seedPhrase: seedPhrase,
      );

      _recoveredAccount = account;

      final walletInfo = account.walletInfo;

      final accountDetails = AccountSummaryData(
        walletConnection: WalletConnectionData(
          name: walletInfo.metadata.name,
          icon: walletInfo.metadata.icon,
        ),
        walletSummary: WalletSummaryData(
          walletName: walletInfo.metadata.name,
          balance: CryptocurrencyFormatter.formatAmount(walletInfo.balance),
          address: WalletAddressFormatter.formatShort(walletInfo.address),
          clipboardAddress: walletInfo.address.toBech32(),
          showLowBalance: false,
          showExpectedNetworkId: null,
        ),
      );

      emit(state.copyWith(accountDetails: Optional(Success(accountDetails))));

      return true;
    } on RegistrationException catch (error, stack) {
      _logger.severe('recover account', error, stack);

      _recoveredAccount = null;

      final exception = LocalizedRegistrationException.from(error);
      emit(state.copyWith(accountDetails: Optional(Failure(exception))));

      return false;
    } catch (error, stack) {
      _logger.severe('recover account', error, stack);

      _recoveredAccount = null;

      final exception = LocalizedException.create(error);
      emit(state.copyWith(accountDetails: Optional(Failure(exception))));

      return false;
    }
  }

  @override
  Future<void> reset() async {
    final recoveredAccount = _recoveredAccount;
    if (recoveredAccount != null) {
      await _userService.removeAccount(recoveredAccount);
    }

    _recoveredAccount = null;

    setSeedPhraseWords([]);
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
  Future<bool> setupKeychain() async {
    final account = _recoveredAccount;
    final seedPhrase = _seedPhrase;
    final password = this.password;

    if (account == null || seedPhrase == null || password.isNotValid) {
      emitError(const LocalizedRegistrationUnknownException());
      return false;
    }

    final lockFactor = PasswordLockFactor(password.value);
    final masterKey = _keyDerivationService.deriveMasterKey(
      seedPhrase: seedPhrase,
    );

    await masterKey.use((masterKey) async {
      final keychain = account.keychain;
      await keychain.setLock(lockFactor);
      await keychain.unlock(lockFactor);
      await keychain.setMasterKey(masterKey);
    });

    await _userService.useAccount(account);

    return true;
  }
}

abstract interface class RecoverManager implements UnlockPasswordManager {
  Future<void> checkLocalKeychains();

  Future<bool> recoverAccount();

  Future<void> reset();

  void setSeedPhraseWords(List<SeedPhraseWord> words);

  Future<bool> setupKeychain();
}
