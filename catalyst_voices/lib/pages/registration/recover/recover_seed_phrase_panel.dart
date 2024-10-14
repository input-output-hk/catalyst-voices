import 'package:catalyst_voices/pages/registration/recover/seed_phrase/account_details_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/seed_phrase_input_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/seed_phrase_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/unlock_password_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/unlock_password_panel.dart';
import 'package:catalyst_voices/pages/registration/widgets/placeholder_panel.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class RecoverSeedPhrasePanel extends StatelessWidget {
  final RecoverSeedPhraseStage stage;

  const RecoverSeedPhrasePanel({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      RecoverSeedPhraseStage.seedPhraseInstructions =>
        const SeedPhraseInstructionsPanel(),
      RecoverSeedPhraseStage.seedPhrase => const SeedPhraseInputPanel(),
      RecoverSeedPhraseStage.accountDetails => const AccountDetailsPanel(),
      RecoverSeedPhraseStage.unlockPasswordInstructions =>
        const UnlockPasswordInstructionsPanel(),
      RecoverSeedPhraseStage.unlockPassword => const UnlockPasswordPanel(),
      RecoverSeedPhraseStage.success => const PlaceholderPanel(),
    };
  }
}
