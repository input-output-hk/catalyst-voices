import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhraseInstructionsPanel extends StatelessWidget {
  const SeedPhraseInstructionsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: RegistrationStageMessage(
              title: Text(
                l10n.recoverySeedPhraseInstructionsTitle,
                key: const Key('SeedPhraseInstructionsTitle'),
              ),
              subtitle: Text(
                l10n.recoverySeedPhraseInstructionsSubtitle,
                key: const Key('SeedPhraseInstructionsSubtitleKey'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const RegistrationBackNextNavigation(),
      ],
    );
  }
}
