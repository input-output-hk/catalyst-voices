import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class UnlockPasswordInstructionsPanel extends StatelessWidget {
  const UnlockPasswordInstructionsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: context.l10n.createKeychainSeedPhraseCheckInstructionsTitle,
          subtitle:
              context.l10n.createKeychainSeedPhraseCheckInstructionsSubtitle,
        ),
        const Spacer(),
        const RegistrationBackNextNavigation(),
      ],
    );
  }
}
