// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:async';
import 'dart:convert' show utf8;

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/registration/cubits/unlock_password_manager.dart';
import 'package:catalyst_voices_blocs/src/registration/state_data/keychain_state_data.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('KeychainCreationCubit');

abstract interface class KeychainCreationManager
    implements UnlockPasswordManager {
  void buildSeedPhrase({
    bool forceRefresh = false,
  });

  void setSeedPhraseStored(bool value);

  void setUserSeedPhraseWords(List<SeedPhraseWord> words);

  Future<void> downloadSeedPhrase();

  Future<bool> createKeychain();
}

final class KeychainCreationCubit extends Cubit<KeychainStateData>
    with BlocErrorEmitterMixin, UnlockPasswordMixin
    implements KeychainCreationManager {
  final Downloader _downloader;
  final RegistrationService _registrationService;

  KeychainCreationCubit({
    required Downloader downloader,
    required RegistrationService registrationService,
  })  : _downloader = downloader,
        _registrationService = registrationService,
        super(const KeychainStateData());

  SeedPhraseStateData get _seedPhraseStateData {
    return state.seedPhraseStateData;
  }

  set _seedPhraseStateData(SeedPhraseStateData newValue) {
    if (state.seedPhraseStateData != newValue) {
      emit(state.copyWith(seedPhraseStateData: newValue));
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
      emitError(const LocalizedRegistrationSeedPhraseNotFoundException());
      return;
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
      emitError(const LocalizedUnknownException());
    }
  }

  @override
  void onUnlockPasswordStateChanged(UnlockPasswordState data) {
    emit(state.copyWith(unlockPasswordState: data));
  }

  @override
  Future<bool> createKeychain() async {
    try {
      final seedPhrase = _seedPhraseStateData.seedPhrase;
      final password = this.password;

      if (seedPhrase == null) {
        throw const LocalizedRegistrationSeedPhraseNotFoundException();
      }
      if (password.isNotValid) {
        throw const LocalizedRegistrationUnlockPasswordNotFoundException();
      }

      await _registrationService.createKeychain(
        seedPhrase: seedPhrase,
        unlockPassword: password.value,
      );

      return true;
    } catch (error, stack) {
      _logger.severe('Create keychain', error, stack);

      emitError(error);

      return false;
    }
  }

  void _buildSeedPhrase() {
    final seedPhrase = SeedPhrase();

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
