/// Describes the keychain creation flow during registration.
enum CreateKeychainStage {
  splash,
  instructions,
  seedPhrase,
  checkSeedPhraseInstructions,
  checkSeedPhrase,
  checkSeedPhraseResult,
  unlockPasswordInstructions,
  unlockPasswordCreate,
}
