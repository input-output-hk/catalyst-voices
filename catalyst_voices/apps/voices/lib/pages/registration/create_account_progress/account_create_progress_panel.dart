import 'package:catalyst_voices/pages/registration/widgets/next_step.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_progress_stepper.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AccountCreateProgressPanel extends StatelessWidget {
  final List<AccountCreateStepType> completedSteps;

  const AccountCreateProgressPanel({
    super.key,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    final lastCompletedStep = completedSteps.lastOrNull;

    final title = lastCompletedStep?._title(context);

    final nextStep = lastCompletedStep?.next;
    final nextStepText = nextStep?._nextStepText(context);

    return Column(
      key: const Key('AccountCreateProgressPanel'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  _TitleText(title),
                  const SizedBox(height: 24),
                ],
                RegistrationProgressStepper(
                  completed: completedSteps.toSet(),
                  current: [...AccountCreateStepType.values]
                      .whereNot(completedSteps.contains)
                      .firstOrNull,
                ),
              ],
            ),
          ),
        ),
        if (nextStepText != null) ...[
          const SizedBox(height: 10),
          NextStep(nextStepText),
        ],
        if (nextStep == AccountCreateStepType.keychain) ...[
          const SizedBox(height: 10),
          _CreateKeychainButton(onTap: () => _goToNextStep(context)),
        ],
        if (nextStep == AccountCreateStepType.walletLink) ...[
          const SizedBox(height: 10),
          _LinkWalletAndRolesButton(onTap: () => _goToNextStep(context)),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  void _goToNextStep(BuildContext context) {
    RegistrationCubit.of(context).nextStep();
  }
}

class _TitleText extends StatelessWidget {
  final String data;

  const _TitleText(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.textOnPrimaryLevel1;

    return Text(
      data,
      style: theme.textTheme.titleMedium?.copyWith(color: color),
    );
  }
}

class _CreateKeychainButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateKeychainButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('CreateKeychainButton'),
      onTap: onTap,
      leading: VoicesAssets.icons.key.buildIcon(size: 18),
      child: Text(context.l10n.accountCreationSplashTitle),
    );
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
      key: const Key('LinkWalletAndRolesButton'),
      onTap: onTap,
      leading: VoicesAssets.icons.wallet.buildIcon(size: 18),
      child: Text(context.l10n.createKeychainLinkWalletAndRoles),
    );
  }
}

extension _AccountCreateStepType on AccountCreateStepType {
  String? _title(BuildContext context) {
    return switch (this) {
      // TODO(damian-molinski): this string may be wrong
      AccountCreateStepType.baseProfile =>
        context.l10n.createBaseProfileCreatedTitle,
      AccountCreateStepType.keychain => context.l10n.createKeychainCreatedTitle,
      AccountCreateStepType.walletLink => null,
    };
  }

  String? _nextStepText(BuildContext context) {
    return switch (this) {
      AccountCreateStepType.baseProfile =>
        context.l10n.createBaseProfileNextStep,
      AccountCreateStepType.keychain =>
        context.l10n.createKeychainCreatedNextStep,
      AccountCreateStepType.walletLink => null,
    };
  }
}
