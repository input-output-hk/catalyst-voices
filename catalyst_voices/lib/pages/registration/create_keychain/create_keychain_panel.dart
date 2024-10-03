import 'package:catalyst_voices/pages/registration/create_keychain/stage/instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_result_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/splash_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/unlock_password_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/unlock_password_panel.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateKeychainPanel extends StatelessWidget {
  final CreateKeychainStage stage;
  final SeedPhraseState seedPhraseState;
  final UnlockPasswordState unlockPasswordState;

  const CreateKeychainPanel({
    super.key,
    required this.stage,
    required this.seedPhraseState,
    required this.unlockPasswordState,
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
        const SeedPhraseCheckInstructionsPanel(),
      CreateKeychainStage.checkSeedPhrase => SeedPhraseCheckPanel(
          seedPhrase: seedPhraseState.seedPhrase,
        ),
      CreateKeychainStage.checkSeedPhraseResult => SeedPhraseCheckResultPanel(
          isCheckConfirmed: seedPhraseState.isCheckConfirmed,
        ),
      CreateKeychainStage.unlockPasswordInstructions =>
        const UnlockPasswordInstructionsPanel(),
      CreateKeychainStage.unlockPasswordCreate => UnlockPasswordPanel(
          data: unlockPasswordState,
        ),
    };
  }
}
