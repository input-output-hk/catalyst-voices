import 'package:catalyst_voices/pages/registration/next_step.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhraseCheckResultPanel extends StatelessWidget {
  final bool isCheckConfirmed;

  const SeedPhraseCheckResultPanel({
    super.key,
    required this.isCheckConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        RegistrationStageMessage(
          title: context.l10n.createKeychainSeedPhraseCheckSuccessTitle,
          subtitle: context.l10n.createKeychainSeedPhraseCheckSuccessSubtitle,
        ),
        const Spacer(),
        NextStep(
          context.l10n.createKeychainSeedPhraseCheckSuccessNextStep,
        ),
        const SizedBox(height: 10),
        RegistrationBackNextNavigation(isNextEnabled: isCheckConfirmed),
      ],
    );
  }
}
