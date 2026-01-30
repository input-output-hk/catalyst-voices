import 'package:catalyst_voices/widgets/indicators/voices_progress_indicator_weight.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingPhaseProgressCard extends StatelessWidget {
  const VotingPhaseProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingPhaseProgressDetailsViewModel?>(
      selector: (state) => state.votingPhase,
      builder: (context, votingPhase) => _VotingPhaseProgressCard(votingPhase: votingPhase),
    );
  }
}

class _Captions extends StatelessWidget {
  final VotingPhaseProgressDetailsViewModel? progress;

  const _Captions({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleSmall?.copyWith(color: theme.colors.textOnPrimaryLevel1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_labelText(context), style: style),
        Text(_valueText(context), style: style),
      ],
    );
  }

  String _formatDuration(BuildContext context, Duration duration) {
    if (duration.inHours >= 1) {
      return DurationFormatter.formatDurationDDhhmm(context.l10n, duration);
    } else {
      return DurationFormatter.formatDurationMMss(context.l10n, duration);
    }
  }

  String _labelText(BuildContext context) {
    return switch (progress?.status) {
      CampaignPhaseStatus.upcoming => context.l10n.votingStarts,
      CampaignPhaseStatus.active => context.l10n.votingPhase,
      CampaignPhaseStatus.post => context.l10n.votingEnded,
      null => '--',
    };
  }

  String _valueText(BuildContext context) {
    final progress = this.progress;
    if (progress == null) return '--';

    return switch (progress.status) {
      CampaignPhaseStatus.upcoming => context.l10n.votingStartsIn(
        _formatDuration(context, progress.currentPhaseEndsIn),
      ),
      CampaignPhaseStatus.active => context.l10n.votingEndsIn(
        _formatDuration(context, progress.currentPhaseEndsIn),
      ),
      CampaignPhaseStatus.post => '--',
    };
  }
}

class _DateRange extends StatelessWidget {
  final DateRange? dateRange;

  const _DateRange({required this.dateRange});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateRange = this.dateRange;

    return Text(
      dateRange != null
          ? DateFormatter.formatDateRange(
              MaterialLocalizations.of(context),
              context.l10n,
              dateRange,
              formatSameWeek: false,
            )
          : '',
      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colors.textOnPrimaryLevel1),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  /// 0.0 - 1.0
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return VoicesLinearProgressIndicator(
      value: value,
      weight: VoicesProgressIndicatorWeight.heavy,
    );
  }
}

class _VotingPhaseProgressCard extends StatelessWidget {
  final VotingPhaseProgressDetailsViewModel? votingPhase;

  const _VotingPhaseProgressCard({
    required this.votingPhase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      constraints: const BoxConstraints(maxWidth: 576),
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VoicesAssets.icons.calendar.buildIcon(
            color: theme.colors.textOnPrimaryLevel1,
            size: 24,
          ),
          const SizedBox(height: 28),
          _VotingStatus(status: votingPhase?.status),
          const SizedBox(height: 4),
          _DateRange(dateRange: votingPhase?.votingDateRange),
          const SizedBox(height: 28),
          _ProgressBar(value: votingPhase?.currentPhaseProgress ?? 0),
          const SizedBox(height: 6),
          _Captions(progress: votingPhase),
        ],
      ),
    );
  }
}

class _VotingStatus extends StatelessWidget {
  final CampaignPhaseStatus? status;

  const _VotingStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      _getText(context),
      style: theme.textTheme.titleMedium?.copyWith(
        fontSize: 18,
        color: theme.colors.textOnPrimaryLevel1,
      ),
    );
  }

  String _getText(BuildContext context) {
    return switch (status) {
      CampaignPhaseStatus.upcoming => context.l10n.getReadyToVote,
      CampaignPhaseStatus.active => context.l10n.votingIsOpen,
      CampaignPhaseStatus.post => context.l10n.votingIsClosed,
      null => '--',
    };
  }
}
