// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:async';
import 'dart:convert' show utf8;

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/state_data/keychain_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('KeychainCreationCubit');

abstract interface class KeychainCreationManager {
  void buildSeedPhrase({
    bool forceRefresh = false,
  });

  void setSeedPhraseStored(bool value);

  void setUserSeedPhraseWords(List<SeedPhraseWord> words);

  Future<void> downloadSeedPhrase();

  void setPassword(String value);

  void setConfirmPassword(String value);

  Future<void> createKeychain();
}

final class KeychainCreationCubit extends Cubit<KeychainStateData>
    implements KeychainCreationManager {
  final Downloader _downloader;

  KeychainCreationCubit({
    required Downloader downloader,
  })  : _downloader = downloader,
        super(const KeychainStateData());

  SeedPhraseStateData get _seedPhraseStateData {
    return state.seedPhraseStateData;
  }

  set _seedPhraseStateData(SeedPhraseStateData newValue) {
    if (state.seedPhraseStateData != newValue) {
      emit(state.copyWith(seedPhraseStateData: newValue));
    }
  }

  UnlockPasswordState get _unlockPasswordState {
    return state.unlockPasswordState;
  }

  set _unlockPasswordState(UnlockPasswordState newValue) {
    if (state.unlockPasswordState != newValue) {
      emit(state.copyWith(unlockPasswordState: newValue));
    }
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

  @override
  void setSeedPhraseStored(bool value) {
    _seedPhraseStateData = _seedPhraseStateData.copyWith(
      isStoredConfirmed: value,
    );
  }

  @override
  void setUserSeedPhraseWords(List<SeedPhraseWord> words) {
    final seedPhrase = _seedPhraseStateData.seedPhrase;
    final seedPhraseWords = seedPhrase?.mnemonicWords;

    final areUserWordsCorrect =
        seedPhraseWords != null && listEquals(seedPhraseWords, words);

    _seedPhraseStateData = _seedPhraseStateData.copyWith(
      userWords: words,
      areUserWordsCorrect: areUserWordsCorrect,
    );
  }

  @override
  Future<void> downloadSeedPhrase() async {
    final mnemonic = _seedPhraseStateData.seedPhrase?.mnemonic;
    if (mnemonic == null) {
      throw StateError('SeedPhrase is not generated. Make sure it exits first');
    }

    FutureOr<Uri> buildWebMnemonicDownloadUri() {
      return Uri.dataFromString(
        mnemonic,
        encoding: utf8,
        base64: true,
      );
    }

    FutureOr<Uri> buildIOMnemonicDownloadUri() {
      throw UnimplementedError();
    }

    final uri = CatalystPlatform.isWeb
        ? await buildWebMnemonicDownloadUri()
        : await buildIOMnemonicDownloadUri();

    final path = Uri(path: 'catalyst_seed_phrase.txt');

    try {
      await _downloader.download(uri, path: path);
    } catch (error, stackTrace) {
      _logger.severe('Downloading keychain failed', error, stackTrace);
      // TODO(damian-molinski): Show snack bar
    }
  }

  @override
  void setPassword(String value) {
    _updateUnlockPasswordState(password: value);
  }

  @override
  void setConfirmPassword(String value) {
    _updateUnlockPasswordState(confirmPassword: value);
  }

  @override
  Future<void> createKeychain() async {
    // TODO(damian-molinski): implement
  }

  void _updateUnlockPasswordState({
    String? password,
    String? confirmPassword,
  }) {
    password ??= _unlockPasswordState.password;
    confirmPassword ??= _unlockPasswordState.confirmPassword;

    const minimumLength = PasswordStrength.minimumLength;

    final passwordStrength = PasswordStrength.calculate(password);
    final correctLength = password.length >= minimumLength;
    final matching = password == confirmPassword;
    final hasConfirmPassword = confirmPassword.isNotEmpty;

    _unlockPasswordState = _unlockPasswordState.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      passwordStrength: passwordStrength,
      showPasswordStrength: password.isNotEmpty,
      minPasswordLength: minimumLength,
      showPasswordMisMatch: correctLength && hasConfirmPassword && !matching,
      isNextEnabled: correctLength && matching,
    );
  }

  void _buildSeedPhrase() {
    // final seedPhrase = SeedPhrase();
    final seedPhrase = SeedPhrase.fromWords(
      const [
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
      ],
    );

    _seedPhraseStateData = _seedPhraseStateData.copyWith(
      seedPhrase: Optional(seedPhrase),
      shuffledWords: seedPhrase.shuffledMnemonicWords,
      // Note. In debug mode we're prefilling correct seed phrase words
      // so its faster to test screens
      userWords: kDebugMode ? seedPhrase.mnemonicWords : const [],
      areUserWordsCorrect: kDebugMode,
    );
  }

  void _ensureSeedPhraseCreated() {
    if (state.seedPhraseStateData.seedPhrase == null) {
      _buildSeedPhrase();
    }
  }
}
