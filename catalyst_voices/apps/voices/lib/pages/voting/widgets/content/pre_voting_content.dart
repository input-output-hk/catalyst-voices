import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/containers/grey_out_container.dart';
import 'package:catalyst_voices/widgets/countdown/campaign_phase_countdown.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class PreVotingContent extends StatelessWidget {
  final CampaignPhase phase;
  final int fundNumber;

  const PreVotingContent({
    super.key,
    required this.phase,
    required this.fundNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 48,
      children: [
        const _Header(),
        Center(
          child: CampaignPhaseCountdown(
            phaseCountdown: CampaignPhaseCountdownViewModel(
              date: phase.timeline.from!,
              type: phase.type,
              fundNumber: fundNumber,
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return GreyOutContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.proposals,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          // TODO(LynxxLynx): unknown if it's final copy text so right now using hardcoded values
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              'Get ready to vote! Final proposals will be displayed here when the voting phase starts.',
              style: context.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
          VoicesFilledButton(
            onTap: () {},
            child: const Text('View Discovery Space'),
          ),
        ],
      ),
    );
  }
}
