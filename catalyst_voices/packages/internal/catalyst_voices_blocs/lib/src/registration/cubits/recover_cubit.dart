// ignore_for_file: one_member_abstracts

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/unlock_password_manager.dart';
import 'package:catalyst_voices_blocs/src/registration/utils/logger_level_ext.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:result_type/result_type.dart';

const _testWords = [
  SeedPhraseWord('asthma', nr: 1),
  SeedPhraseWord('moral', nr: 2),
  SeedPhraseWord('actress', nr: 3),
  SeedPhraseWord('venue', nr: 4),
  SeedPhraseWord('waste', nr: 5),
  SeedPhraseWord('include', nr: 6),
  SeedPhraseWord('oven', nr: 7),
  SeedPhraseWord('outdoor', nr: 8),
  SeedPhraseWord('record', nr: 9),
  SeedPhraseWord('blouse', nr: 10),
  SeedPhraseWord('abuse', nr: 11),
  SeedPhraseWord('vague', nr: 12),
];

final _logger = Logger('RecoverCubit');

@visibleForTesting
List<SeedPhraseWord> get recoverTestWords => List.unmodifiable(_testWords);

/// Manages the recovery process.
///
/// Allows to recover an account from the seed phrase.
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
  }) : _userService = userService,
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

      final account = await _registrationService
          .recoverAccount(seedPhrase: seedPhrase)
          .onError<NotFoundException>((_, _) => throw const LocalizedRecoverAccountNotFound());

      final address = account.address!;
      final balance = await _registrationService
          .getWalletBalance(
            seedPhrase: seedPhrase,
            address: address,
          )
          .onError<Object>(
            (error, stackTrace) {
              _logger.warning('Failed to get wallet balance', error, stackTrace);
              if (!isClosed) emitError(const LocalizedWalletBalanceException());
              return const Coin(0);
            },
          );

      _recoveredAccount = account;

      final accountDetails = AccountSummaryData(
        username: account.username,
        email: account.email,
        roles: account.roles,
        formattedAddress: WalletAddressFormatter.formatShort(address),
        clipboardAddress: address,
        balance: MoneyFormatter.formatCompactRounded(balance.toMoney()),
      );

      emit(state.copyWith(accountDetails: Optional(Success(accountDetails))));

      return true;
    } catch (error, stack) {
      _logger.log(error.level, 'recover account', error, stack);

      _recoveredAccount = null;

      final exception = LocalizedRegistrationException.create(error);

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
    final mnemonic = words.toMnemonic();
    final isValid = SeedPhrase.isValid(mnemonic: mnemonic);
    if (isValid) {
      _seedPhrase = SeedPhrase.fromMnemonic(mnemonic);
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

    await _userService.recoverAccount(account);

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
