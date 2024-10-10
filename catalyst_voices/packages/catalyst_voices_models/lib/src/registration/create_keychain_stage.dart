/// Describes the keychain creation flow during registration.
enum CreateKeychainStage {
  /// The welcome stage.
  splash,

  /// Givens context to user about what is seed phrase.
  instructions,

  /// Shows generated seed phrase.
  seedPhrase,

  /// Gives information's about checking seed phrase importance.
  checkSeedPhraseInstructions,

  /// Checking whether user remembers correct seed phrase.
  checkSeedPhrase,

  /// Shows information's about correctness of seed phrase
  /// from [checkSeedPhrase].
  checkSeedPhraseResult,

  /// Explains why need unlock password and where it can be used. This
  /// device only.
  unlockPasswordInstructions,

  /// Password creation stage.
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
