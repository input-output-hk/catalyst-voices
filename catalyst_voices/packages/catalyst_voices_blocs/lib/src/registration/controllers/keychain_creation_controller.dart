// ignore_for_file: one_member_abstracts
// ignore_for_file: avoid_positional_boolean_parameters

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';

final class KeychainCreationController with ChangeNotifier {
  // ignore: prefer_final_fields
  SeedPhrase _seedPhrase = SeedPhrase();
  bool _isSeedPhraseStoredConfirmed = false;

  KeychainCreationController();

  void handleEvent(KeychainCreationEvent event) {
    switch (event) {
      case SeedPhraseStoreConfirmationEvent():
        if (_isSeedPhraseStoredConfirmed != event.value) {
          _isSeedPhraseStoredConfirmed = event.value;
          notifyListeners();
        }
    }
  }

  CreateKeychain buildState(CreateKeychainStage stage) {
    return CreateKeychain(
      stage: stage,
      seedPhraseState: SeedPhraseState(
        seedPhrase: _seedPhrase,
        isStoredConfirmed: _isSeedPhraseStoredConfirmed,
      ),
    );
  }

  CreateKeychainStep? nextStep(CreateKeychainStage stage) {
    final currentStageIndex = CreateKeychainStage.values.indexOf(stage);
    final isLast = currentStageIndex == CreateKeychainStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = CreateKeychainStage.values[currentStageIndex + 1];
    return CreateKeychainStep(stage: nextStage);
  }

  CreateKeychainStep? previousStep(CreateKeychainStage stage) {
    final currentStageIndex = CreateKeychainStage.values.indexOf(stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = CreateKeychainStage.values[currentStageIndex - 1];
    return CreateKeychainStep(stage: previousStage);
  }
}
