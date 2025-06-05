// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:async';
import 'dart:convert' show utf8;

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/unlock_password_manager.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('KeychainCreationCubit');

final class KeychainCreationCubit extends Cubit<KeychainStateData>
    with BlocErrorEmitterMixin, UnlockPasswordMixin
    implements KeychainCreationManager {
  final DownloaderService _downloaderService;

  SeedPhrase? _seedPhrase;

  KeychainCreationCubit({
    required DownloaderService downloaderService,
  })  : _downloaderService = downloaderService,
        super(const KeychainStateData());

  SeedPhrase? get seedPhrase => _seedPhrase;

  SeedPhraseStateData get _seedPhraseStateData {
    return state.seedPhraseStateData;
  }

  set _seedPhraseStateData(SeedPhraseStateData newValue) {
    if (state.seedPhraseStateData != newValue) {
      emit(state.copyWith(seedPhraseStateData: newValue));
    }
  }

  @override
  bool areWordsMatching(List<SeedPhraseWord> words) {
    final seedPhrase = _seedPhrase;
    final seedPhraseWords = seedPhrase?.mnemonicWords;

    final sortedWords = [...words]..sort();

    return listEquals(seedPhraseWords, sortedWords);
  }

  @override
  void buildSeedPhrase({
    bool forceRefresh = false,
  }) {
    if (forceRefresh) {
      _buildSeedPhrase();
    } else {
      _ensureSeedPhraseCreated();
    }
  }

  KeychainProgress createRecoverProgress() {
    return KeychainProgress(
      seedPhrase: _seedPhrase!,
      password: password.value,
    );
  }

  @override
  Future<void> exportSeedPhrase() async {
    final mnemonic = _seedPhrase?.mnemonic;
    if (mnemonic == null) {
      emitError(const LocalizedRegistrationSeedPhraseNotFoundException());
      return;
    }

    try {
      await _downloaderService.download(
        data: utf8.encode(mnemonic),
        filename: 'catalyst_seed_phrase.txt',
      );
    } catch (error, stackTrace) {
      _logger.severe('Downloading keychain failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    }
  }

  @override
  void onUnlockPasswordStateChanged(UnlockPasswordState data) {
    emit(state.copyWith(unlockPasswordState: data));
  }

  void recoverSeedPhrase(SeedPhrase value) {
    _seedPhrase = value;
    setSeedPhraseStored(true);
    setUserSeedPhraseWords(value.mnemonicWords);
  }

  @override
  void setSeedPhraseStored(bool value) {
    _seedPhraseStateData = _seedPhraseStateData.copyWith(
      isStoredConfirmed: value,
    );
  }

  @override
  void setUserSeedPhraseWords(List<SeedPhraseWord> words) {
    final seedPhrase = _seedPhrase;
    final seedPhraseWords = seedPhrase?.mnemonicWords;

    final allSelected = words.length == seedPhraseWords?.length;
    final matches = listEquals(seedPhraseWords, words);

    if (allSelected && !matches) {
      emitError(const LocalizedSeedPhraseWordsDoNotMatchException());
    }

    _seedPhraseStateData = _seedPhraseStateData.copyWith(
      userWords: words,
      areUserWordsCorrect: matches,
    );
  }

  void _buildSeedPhrase() {
    final seedPhrase = SeedPhrase();
    _seedPhrase = seedPhrase;

    _seedPhraseStateData = _seedPhraseStateData.copyWith(
      seedPhraseWords: seedPhrase.mnemonicWords,
      shuffledWords: seedPhrase.shuffledMnemonicWords,
      // Note. In debug mode we're prefilling correct seed phrase words
      // so its faster to test screens
      userWords: kDebugMode ? seedPhrase.mnemonicWords : const [],
      areUserWordsCorrect: kDebugMode,
    );
  }

  void _ensureSeedPhraseCreated() {
    if (_seedPhrase == null) {
      _buildSeedPhrase();
    }
  }
}

abstract interface class KeychainCreationManager implements UnlockPasswordManager {
  bool areWordsMatching(List<SeedPhraseWord> words);

  void buildSeedPhrase({
    bool forceRefresh = false,
  });

  Future<void> exportSeedPhrase();

  void setSeedPhraseStored(bool value);

  void setUserSeedPhraseWords(List<SeedPhraseWord> words);
}
