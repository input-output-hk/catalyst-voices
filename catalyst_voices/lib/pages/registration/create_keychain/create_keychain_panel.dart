import 'package:catalyst_voices/pages/registration/create_keychain/stage/stages.dart';
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
      CreateKeychainStage.checkSeedPhraseInstructions ||
      CreateKeychainStage.checkSeedPhrase ||
      CreateKeychainStage.checkSeedPhraseResult ||
      CreateKeychainStage.unlockPasswordInstructions ||
      CreateKeychainStage.unlockPasswordCreate ||
      CreateKeychainStage.created =>
        const Placeholder(),
    };
  }
}
