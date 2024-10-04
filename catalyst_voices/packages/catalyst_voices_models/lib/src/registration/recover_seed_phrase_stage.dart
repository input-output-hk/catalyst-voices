/// Describes the seed phrase recovery method flow.
enum RecoverSeedPhraseStage {
  /// Provides user with brief information's about seed phrase words.
  seedPhraseInstructions,

  /// Where user enters 12 words for seed phrase.
  seedPhrase,

  /// Shows details about linked wallet to the account.
  linkedWallet,

  /// Explains why need unlock password and where it can be used. This
  /// device only.
  unlockPasswordInstructions,

  /// Password creation stage.
  unlockPassword,

  /// Confirmation screen.
  success,
}
