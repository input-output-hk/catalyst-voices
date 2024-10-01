import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/stages.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateKeychainPanel extends StatelessWidget {
  final CreateKeychainStage stage;
  final SeedPhraseState seedPhraseState;

  const CreateKeychainPanel({
    super.key,
    required this.stage,
    required this.seedPhraseState,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      CreateKeychainStage.splash => const SplashPanel(),
      CreateKeychainStage.instructions => const InstructionsPanel(),
      CreateKeychainStage.seedPhrase => SeedPhrasePanel(
          seedPhrase: seedPhraseState.seedPhrase,
          isStoreSeedPhraseConfirmed: seedPhraseState.isStoredConfirmed,
          isNextEnabled: seedPhraseState.isStoredConfirmed,
        ),
      CreateKeychainStage.checkSeedPhraseInstructions => const Placeholder(),
      CreateKeychainStage.checkSeedPhrase => SeedPhraseCheckPanel(
          seedPhrase: seedPhraseState.seedPhrase,
        ),
      CreateKeychainStage.checkSeedPhraseResult ||
      CreateKeychainStage.unlockPasswordInstructions ||
      CreateKeychainStage.unlockPasswordCreate ||
      CreateKeychainStage.created =>
        const Placeholder(),
    };
  }
}
