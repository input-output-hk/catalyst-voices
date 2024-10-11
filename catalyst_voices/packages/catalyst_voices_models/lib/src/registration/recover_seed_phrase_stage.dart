/// Describes the seed phrase recovery method flow.
enum RecoverSeedPhraseStage {
  /// Provides user with brief information's about seed phrase words.
  seedPhraseInstructions,

  /// Where user enters 12 words for seed phrase.
  seedPhrase,

  /// Shows details about restored account.
  accountDetails,

  /// Explains why need unlock password and where it can be used. This
  /// device only.
  unlockPasswordInstructions,

  /// Password creation stage.
  unlockPassword,

  /// Confirmation screen.
  success;

  RecoverSeedPhraseStage? get next {
    final index = RecoverSeedPhraseStage.values.indexOf(this);
    final isLast = index == RecoverSeedPhraseStage.values.length - 1;
    if (isLast) {
      return null;
    }

    return RecoverSeedPhraseStage.values[index + 1];
  }

  RecoverSeedPhraseStage? get previous {
    final index = RecoverSeedPhraseStage.values.indexOf(this);
    final isFirst = index == 0;
    if (isFirst) {
      return null;
    }

    return RecoverSeedPhraseStage.values[index - 1];
  }
}
