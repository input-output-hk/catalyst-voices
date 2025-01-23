import 'package:catalyst_voices/pages/registration/recover/seed_phrase/account_details_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/restored_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/seed_phrase_input_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/seed_phrase_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/unlock_password_instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/recover/seed_phrase/unlock_password_panel.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class RecoverSeedPhrasePanel extends StatelessWidget {
  final RecoverWithSeedPhraseStage stage;

  const RecoverSeedPhrasePanel({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      RecoverWithSeedPhraseStage.seedPhraseInstructions =>
        const SeedPhraseInstructionsPanel(),
      RecoverWithSeedPhraseStage.seedPhrase => const SeedPhraseInputPanel(),
      RecoverWithSeedPhraseStage.accountDetails => const AccountDetailsPanel(),
      RecoverWithSeedPhraseStage.unlockPasswordInstructions =>
        const UnlockPasswordInstructionsPanel(),
      RecoverWithSeedPhraseStage.unlockPassword => const UnlockPasswordPanel(),
      RecoverWithSeedPhraseStage.success => const RestoredPanel(),
    };
  }
}
