// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:async';
import 'dart:convert' show utf8;

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('KeychainCreationCubit');

final class KeychainCreationCubit extends Cubit<CreateKeychain> {
  final Downloader _downloader;

  KeychainCreationCubit({
    required Downloader downloader,
  })  : _downloader = downloader,
        super(const CreateKeychain());

  set _seedPhrase(SeedPhraseState newValue) {
    emit(state.copyWith(seedPhrase: newValue));
  }

  SeedPhraseState get _seedPhrase => state.seedPhrase;

  set _unlockPassword(UnlockPasswordState newValue) {
    emit(state.copyWith(unlockPassword: newValue));
  }

  UnlockPasswordState get _unlockPassword => state.unlockPassword;

  void changeStage(CreateKeychainStage newValue) {
    if (state.stage != newValue) {
      emit(state.copyWith(stage: newValue));
    }
  }

  void buildSeedPhrase() {
    final seedPhrase = SeedPhrase();
    _seedPhrase = _seedPhrase.copyWith(
      seedPhrase: Optional.of(seedPhrase),
    );
  }

  void ensureSeedPhraseCreated() {
    if (_seedPhrase.seedPhrase == null) {
      buildSeedPhrase();
    }
  }

  void setSeedPhraseStoredConfirmed(bool newValue) {
    if (_seedPhrase.isStoredConfirmed != newValue) {
      _seedPhrase = _seedPhrase.copyWith(isStoredConfirmed: newValue);
    }
  }

  void setSeedPhraseCheckConfirmed({
    required bool isConfirmed,
  }) {
    if (_seedPhrase.isCheckConfirmed != isConfirmed) {
      _seedPhrase = _seedPhrase.copyWith(isCheckConfirmed: isConfirmed);
    }
  }

  Future<void> downloadSeedPhrase() async {
    final mnemonic = _seedPhrase.seedPhrase?.mnemonic;
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

  void setPassword(String newValue) {
    if (_unlockPassword.password != newValue) {
      _updateUnlockPasswordState(password: newValue);
    }
  }

  void setConfirmPassword(String newValue) {
    if (_unlockPassword.confirmPassword != newValue) {
      _updateUnlockPasswordState(confirmPassword: newValue);
    }
  }

  // TODO(damian-molinski): implement
  Future<void> createKeychain() async {}

  void _updateUnlockPasswordState({
    String? password,
    String? confirmPassword,
  }) {
    password ??= _unlockPassword.password;
    confirmPassword ??= _unlockPassword.confirmPassword;

    const minimumLength = PasswordStrength.minimumLength;

    final passwordStrength = PasswordStrength.calculate(password);
    final correctLength = password.length >= minimumLength;
    final matching = password == confirmPassword;
    final hasConfirmPassword = confirmPassword.isNotEmpty;

    _unlockPassword = _unlockPassword.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      passwordStrength: passwordStrength,
      showPasswordStrength: password.isNotEmpty,
      minPasswordLength: minimumLength,
      showPasswordMisMatch: correctLength && hasConfirmPassword && !matching,
      isNextEnabled: correctLength && matching,
    );
  }

  CreateKeychainStep? nextStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(state.stage);
    final isLast = currentStageIndex == CreateKeychainStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = CreateKeychainStage.values[currentStageIndex + 1];
    return CreateKeychainStep(stage: nextStage);
  }

  CreateKeychainStep? previousStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(state.stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = CreateKeychainStage.values[currentStageIndex - 1];
    return CreateKeychainStep(stage: previousStage);
  }
}
