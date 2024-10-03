import 'package:catalyst_voices/pages/registration/create_keychain/stage/instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_check_result_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/seed_phrase_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/splash_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/unlock_password_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_keychain/stage/unlock_password_panel.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateKeychainPanel extends StatelessWidget {
  final CreateKeychainStage stage;

  const CreateKeychainPanel({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      CreateKeychainStage.splash => const SplashPanel(),
      CreateKeychainStage.instructions => const InstructionsPanel(),
      CreateKeychainStage.seedPhrase => const SeedPhrasePanel(),
      CreateKeychainStage.checkSeedPhraseInstructions =>
        const SeedPhraseCheckInstructionsPanel(),
      CreateKeychainStage.checkSeedPhrase => const SeedPhraseCheckPanel(),
      CreateKeychainStage.checkSeedPhraseResult =>
        const SeedPhraseCheckResultPanel(),
      CreateKeychainStage.unlockPasswordInstructions =>
        const UnlockPasswordInstructionsPanel(),
      CreateKeychainStage.unlockPasswordCreate => const UnlockPasswordPanel(),
    };
  }
}
