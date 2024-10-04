import 'package:catalyst_voices/pages/registration/widgets/placeholder_panel.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class RoverSeedPhrasePanel extends StatelessWidget {
  final RecoverSeedPhraseStage stage;

  const RoverSeedPhrasePanel({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      RecoverSeedPhraseStage.seedPhraseInstructions => const PlaceholderPanel(),
      RecoverSeedPhraseStage.seedPhrase => const PlaceholderPanel(),
      RecoverSeedPhraseStage.linkedWallet => const PlaceholderPanel(),
      RecoverSeedPhraseStage.unlockPasswordInstructions =>
        const PlaceholderPanel(),
      RecoverSeedPhraseStage.unlockPassword => const PlaceholderPanel(),
      RecoverSeedPhraseStage.success => const PlaceholderPanel(),
    };
  }
}
