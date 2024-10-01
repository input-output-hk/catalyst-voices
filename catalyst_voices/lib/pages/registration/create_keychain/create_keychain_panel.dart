import 'package:catalyst_voices/pages/registration/create_keychain/stage/check_seed_phrase_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_result_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/splash_panel.dart';
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
      CreateKeychainStage.checkSeedPhraseInstructions =>
        const CheckSeedPhraseInstructionsPanel(),
      CreateKeychainStage.checkSeedPhrase => SeedPhraseCheckPanel(
          seedPhrase: seedPhraseState.seedPhrase,
        ),
      CreateKeychainStage.checkSeedPhraseResult => SeedPhraseCheckResultPanel(
          isCheckConfirmed: seedPhraseState.isCheckConfirmed,
        ),
      CreateKeychainStage.unlockPasswordInstructions ||
      CreateKeychainStage.unlockPasswordCreate ||
      CreateKeychainStage.created =>
        const Placeholder(),
    };
  }
}
