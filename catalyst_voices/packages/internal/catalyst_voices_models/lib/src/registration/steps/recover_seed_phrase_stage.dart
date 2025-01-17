/// Describes the seed phrase recovery method flow.
enum RecoverWithSeedPhraseStage {
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

  RecoverWithSeedPhraseStage? get next {
    final index = RecoverWithSeedPhraseStage.values.indexOf(this);
    final isLast = index == RecoverWithSeedPhraseStage.values.length - 1;
    if (isLast) {
      return null;
    }

    return RecoverWithSeedPhraseStage.values[index + 1];
  }

  RecoverWithSeedPhraseStage? get previous {
    final index = RecoverWithSeedPhraseStage.values.indexOf(this);
    final isFirst = index == 0;
    if (isFirst) {
      return null;
    }

    return RecoverWithSeedPhraseStage.values[index - 1];
  }
}
