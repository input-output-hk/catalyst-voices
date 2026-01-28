import 'package:catalyst_voices/pages/registration/widgets/next_step.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_details_panel_scaffold.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class WalletDrepLinkCompletedPanel extends StatelessWidget {
  const WalletDrepLinkCompletedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegistrationDetailsPanelScaffold(
      body: SingleChildScrollView(child: _Body()),
      footer: _Footer(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TitleText(),
        SizedBox(height: 10),
        _RolesUpdatedCard(),
        SizedBox(height: 32),
        _Summary(),
      ],
    );
  }
}

class _CreateDrepProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateDrepProfileButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: onTap,
      child: Text(
        context.l10n.drepLinkCompletedCreateProfileButton,
        semanticsIdentifier: 'CreateRepresentativeProfileButton',
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _NextStep(),
        const SizedBox(height: 12),
        _CreateDrepProfileButton(
          onTap: () {
            Navigator.pop(context);
            // TODO(bstolinski): open profile builder page
          },
        ),
        const SizedBox(height: 12),
        _SkipButton(onTap: () => Navigator.pop(context)),
      ],
    );
  }
}

class _NextStep extends StatelessWidget {
  const _NextStep();

  @override
  Widget build(BuildContext context) {
    return const NextStep(null);
  }
}

class _RolesFooter extends StatelessWidget {
  const _RolesFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.l10n.drepLinkCompletedRoleAdded,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: VoicesChip(
            padding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 6,
            ),
            content: Text(
              context.l10n.drepLinkCompletedRoleTitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colors.successContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            backgroundColor: Theme.of(context).colors.success,
          ),
        ),
        Text(
          context.l10n.drepLinkCompletedRoleRegistration,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _RolesUpdatedCard extends StatelessWidget {
  const _RolesUpdatedCard();

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      icon: VoicesAssets.icons.summary.buildIcon(),
      title: Text(context.l10n.drepLinkCompletedRolesUpdatedTitle),
      desc: Text(context.l10n.drepLinkCompletedRolesUpdatedInfo),
      statusIcon: VoicesAssets.icons.check.buildIcon(),
      isExpanded: true,
      body: const _RolesFooter(),
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      onTap: onTap,
      child: Text(
        context.l10n.drepLinkCompletedSkipButton,
        semanticsIdentifier: 'SkipButton',
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.drepLinkCompletedWhatNextTitle,
          style: textTheme.titleMedium?.copyWith(
            color: colors.textOnPrimaryLevel1,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          context.l10n.drepLinkCompletedWhatNextMessage,
          style: textTheme.bodySmall?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.textOnPrimaryLevel1;

    return Text(
      context.l10n.drepLinkCompletedSummaryHeader,
      style: theme.textTheme.titleMedium?.copyWith(color: color),
    );
  }
}
