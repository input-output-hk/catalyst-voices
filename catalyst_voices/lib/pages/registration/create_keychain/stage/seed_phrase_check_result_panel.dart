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
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        // TODO(damian-molinski): use correct strings when available.
        Expanded(
          child: SingleChildScrollView(
            child: RegistrationStageMessage(
              title: Text(
                isCheckConfirmed
                    ? l10n.createKeychainSeedPhraseCheckSuccessTitle
                    : 'Seed phrase words does not match!',
              ),
              subtitle: Text(
                isCheckConfirmed
                    ? l10n.createKeychainSeedPhraseCheckSuccessSubtitle
                    : 'Go back ana make sure order is correct',
              ),
            ),
          ),
        ),
        if (isCheckConfirmed)
          NextStep(l10n.createKeychainSeedPhraseCheckSuccessNextStep),
        const SizedBox(height: 10),
        RegistrationBackNextNavigation(isNextEnabled: isCheckConfirmed),
      ],
    );
  }
}
