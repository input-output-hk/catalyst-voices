import 'package:catalyst_voices/pages/registration/next_step.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
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
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.createKeychainSeedPhraseCheckSuccessTitle,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.createKeychainSeedPhraseCheckSuccessSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        const Spacer(),
        NextStep(
          context.l10n.createKeychainSeedPhraseCheckSuccessNextStep,
        ),
        const SizedBox(height: 10),
        BackNextNavigation(isNextEnabled: isCheckConfirmed),
      ],
    );
  }
}
