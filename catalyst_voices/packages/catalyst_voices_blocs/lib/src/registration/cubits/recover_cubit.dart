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
}

final class RecoverCubit extends Cubit<RecoverStateData>
    with BlocErrorEmitterMixin, UnlockPasswordMixin
    implements RecoverManager {
  final RegistrationService _registrationService;

  SeedPhrase? _seedPhrase;

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
      if (seedPhrase == null) {
        const exception = LocalizedRegistrationSeedPhraseNotFoundException();
        emit(state.copyWith(accountDetails: Optional(Failure(exception))));
        return;
      }

      final walletDetails =
          await _registrationService.recoverCardanoWalletDetails(seedPhrase);

      final accountDetails = AccountSummaryData(
        walletConnection: WalletConnectionData(
          name: walletDetails.wallet.name,
          icon: walletDetails.wallet.icon,
        ),
        walletSummary: WalletSummaryData(
          balance: CryptocurrencyFormatter.formatAmount(walletDetails.balance),
          address: WalletAddressFormatter.formatShort(walletDetails.address),
          clipboardAddress: walletDetails.address.toBech32(),
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
