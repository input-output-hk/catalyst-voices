import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListCampaignPhaseProgress extends StatelessWidget {
  const VotingListCampaignPhaseProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, VotingListCampaignPhaseData>(
      selector: (state) => state.votingProgress,
      builder: (context, state) {
        return _VotingListCampaignPhaseProgress(data: state);
      },
    );
  }
}

class _VotingListCampaignPhaseProgress extends StatelessWidget {
  final VotingListCampaignPhaseData data;

  const _VotingListCampaignPhaseProgress({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final votingEndsIn = data.votingEndsIn;

    final textStyle = (context.textTheme.labelMedium ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel1,
    );

    return DefaultTextStyle(
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          VoicesLinearProgressIndicator(value: data.votingPhaseProgress),
          Row(
            spacing: 6,
            children: [
              Expanded(
                child: _VotingListCampaignPhaseProgressOverviewText(
                  activeFundNumber: data.activeFundNumber,
                ),
              ),
              if (votingEndsIn != null)
                _VotingListCampaignPhaseProgressEndsInText(duration: votingEndsIn),
            ],
          ),
        ],
      ),
    );
  }
}

class _VotingListCampaignPhaseProgressEndsInText extends StatelessWidget {
  final Duration duration;

  const _VotingListCampaignPhaseProgressEndsInText({
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      duration > Duration.zero
          ? context.l10n.votingEndsIn(
              DurationFormatter.formatDurationDDhhmm(context.l10n, duration),
            )
          : context.l10n.ended,
    );
  }
}

class _VotingListCampaignPhaseProgressOverviewText extends StatelessWidget {
  final int? activeFundNumber;

  const _VotingListCampaignPhaseProgressOverviewText({
    this.activeFundNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _buildParts(context).join(' · '),
      textAlign: TextAlign.start,
    );
  }

  List<String> _buildParts(BuildContext context) {
    return [
      if (activeFundNumber != null) context.l10n.fundX(activeFundNumber!),
      context.l10n.votingPhase,
    ];
  }
}
