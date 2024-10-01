import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class CheckSeedPhraseInstructionsPanel extends StatelessWidget {
  const CheckSeedPhraseInstructionsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colors.textOnPrimaryLevel0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.createKeychainSeedPhraseCheckInstructionsTitle,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.createKeychainSeedPhraseCheckInstructionsSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        const Spacer(),
        const _Navigation(),
      ],
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VoicesBackButton(
            onTap: () => RegistrationCubit.of(context).previousStep(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: VoicesNextButton(
            onTap: () => RegistrationCubit.of(context).nextStep(),
          ),
        ),
      ],
    );
  }
}
