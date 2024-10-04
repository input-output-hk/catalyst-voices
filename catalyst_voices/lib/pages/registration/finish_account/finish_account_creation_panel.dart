import 'package:catalyst_voices/pages/registration/next_step.dart';
import 'package:catalyst_voices/pages/registration/registration_progress.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class FinishAccountCreationPanel extends StatelessWidget {
  const FinishAccountCreationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TitleText(),
                SizedBox(height: 24),
                RegistrationProgressKeychainCompleted(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const _NextStep(),
        const SizedBox(height: 10),
        _LinkWalletAndRolesButton(onTap: () => _goToNextStep(context)),
      ],
    );
  }

  void _goToNextStep(BuildContext context) {
    RegistrationCubit.of(context).nextStep();
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.textOnPrimaryLevel1;

    final l10n = context.l10n;

    return Text(
      l10n.createKeychainCreatedTitle,
      style: theme.textTheme.titleMedium?.copyWith(color: color),
    );
  }
}

class _NextStep extends StatelessWidget {
  const _NextStep();

  @override
  Widget build(BuildContext context) {
    return NextStep(context.l10n.createKeychainCreatedNextStep);
  }
}

class _LinkWalletAndRolesButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LinkWalletAndRolesButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      leading: VoicesAssets.icons.wallet.buildIcon(size: 18),
      child: Text(context.l10n.createKeychainLinkWalletAndRoles),
    );
  }
}
