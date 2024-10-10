// ignore_for_file: one_member_abstracts

import 'dart:math';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

abstract interface class RecoverManager {
  Future<void> checkLocalKeychains();

  void setSeedPhraseWords(List<SeedPhraseWord> words);

  Future<void> recoverAccount();
}

final class RecoverCubit extends Cubit<RecoverStateData>
    implements RecoverManager {
  SeedPhrase? _seedPhrase;

  RecoverCubit() : super(const RecoverStateData()) {
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
    emit(state.copyWith(accountDetails: const Optional.empty()));

    await Future<void>.delayed(const Duration(milliseconds: 200));

    final seedPhrase = _seedPhrase;
    // TODO(damian-molinski): to be implemented
    final isSuccess = seedPhrase != null && Random().nextBool();

    final coin = Coin.fromAda(10);
    final address = ShelleyAddress(const [0]);

    final accountDetails = isSuccess
        ? Success<AccountSummaryData, Exception>(
            AccountSummaryData(
              walletConnection: const WalletConnectionData(
                name: 'Test Wallet',
              ),
              walletSummary: WalletSummaryData(
                balance: CryptocurrencyFormatter.formatAmount(coin),
                address: WalletAddressFormatter.formatShort(address),
                clipboardAddress: address.toBech32(),
                showLowBalance: false,
              ),
            ),
          )
        : Failure<AccountSummaryData, Exception>(Exception());

    emit(state.copyWith(accountDetails: Optional(accountDetails)));
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
