/// Describes the keychain creation flow during registration.
enum CreateKeychainStage {
  splash,
  instructions,
  seedPhrase,
  checkSeedPhraseInstructions,
  checkSeedPhrase,
  checkSeedPhraseResult,
  unlockPasswordInstructions,
  unlockPasswordCreate;

  CreateKeychainStage? get next {
    final index = CreateKeychainStage.values.indexOf(this);
    final isLast = index == CreateKeychainStage.values.length - 1;
    if (isLast) {
      return null;
    }

    return CreateKeychainStage.values[index + 1];
  }

  CreateKeychainStage? get previous {
    final index = CreateKeychainStage.values.indexOf(this);
    final isFirst = index == 0;
    if (isFirst) {
      return null;
    }

    return CreateKeychainStage.values[index - 1];
  }
}
