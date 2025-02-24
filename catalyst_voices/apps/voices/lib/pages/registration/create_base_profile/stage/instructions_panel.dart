import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InstructionsPanel extends StatelessWidget {
  const InstructionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: _PanelMainMessage(),
          ),
        ),
        SizedBox(height: 12),
        _ExplanationText(
          key: Key('BaseProfileExplanationTest'),
        ),
        SizedBox(height: 8),
        _EmailRequestCard(),
        SizedBox(height: 24),
        _NextButton(),
      ],
    );
  }
}

class _PanelMainMessage extends StatelessWidget {
  const _PanelMainMessage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RegistrationStageMessage(
      title: Text(l10n.createBaseProfileInstructionsTitle),
      subtitle: Text(l10n.createBaseProfileInstructionsMessage),
    );
  }
}

class _ExplanationText extends StatelessWidget {
  const _ExplanationText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final textStyle = (textTheme.titleMedium ?? const TextStyle()).copyWith(
      color: theme.colors.textOnPrimaryLevel1,
    );

    return Text(
      key: key ?? const Key('ExplanationText'),
      context.l10n.headsUp,
      style: textStyle,
    );
  }
}

class _EmailRequestCard extends StatelessWidget {
  const _EmailRequestCard();

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      key: const Key('EmailRequestCard'),
      icon: VoicesAssets.icons.mailOpen.buildIcon(),
      title: Text(
        context.l10n.createBaseProfileInstructionsEmailRequest,
        key: const Key('EmailRequestTitle'),
      ),
      desc: BulletList(
        key: const Key('EmailRequestList'),
        items: [
          context.l10n.createBaseProfileInstructionsEmailReason1,
          context.l10n.createBaseProfileInstructionsEmailReason2,
          context.l10n.createBaseProfileInstructionsEmailReason3,
        ],
        spacing: 0,
      ),
      statusIcon: VoicesAssets.icons.informationCircle.buildIcon(),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('CreateBaseProfileNext'),
      onTap: () => RegistrationCubit.of(context).nextStep(),
      child: Text(context.l10n.createBaseProfileInstructionsNext),
    );
  }
}
