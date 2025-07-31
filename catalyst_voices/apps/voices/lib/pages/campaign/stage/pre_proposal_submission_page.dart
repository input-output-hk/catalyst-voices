import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/stage/campaign_background.dart';
import 'package:catalyst_voices/widgets/countdown/campaign_phase_countdown.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class PreProposalSubmissionPage extends StatelessWidget {
  final CampaignPhaseCountdownViewModel phaseCountdown;
  final ValueChanged<bool>? onCountdownEnd;

  const PreProposalSubmissionPage({super.key, required this.phaseCountdown, this.onCountdownEnd});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeBuilder.buildTheme(),
      child: CampaignBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(phaseCountdown.fundNumber),
            const SizedBox(height: 12),
            CampaignPhaseCountdown(phaseCountdown: phaseCountdown),
            const SizedBox(height: 48),
            const _Description(),
            const SizedBox(height: 24),
            const _ActionButton(),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget with LaunchUrlMixin {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () async {
        await launchUri(VoicesConstants.beforeSubmissionUrl.getUri());
      },
      child: Text(context.l10n.learnMore),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.preSubmitProposalStageDescription,
      textAlign: TextAlign.center,
      style: context.textTheme.bodyLarge,
    );
  }
}

class _Header extends StatelessWidget {
  final int fundNumber;

  const _Header(this.fundNumber);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.catalystFundNo(fundNumber.toString()),
      style: context.textTheme.displaySmall?.copyWith(
        color: context.colorScheme.primary,
      ),
    );
  }
}
