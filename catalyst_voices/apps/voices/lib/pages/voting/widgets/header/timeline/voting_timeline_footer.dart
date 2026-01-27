part of 'voting_timeline_header.dart';

class _Countdown extends StatelessWidget {
  final VotingTimelinePhaseType phaseType;
  final Duration phaseEndsIn;

  const _Countdown({
    required this.phaseType,
    required this.phaseEndsIn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = _formatDuration(context, phaseEndsIn);
    final countdownText = switch (phaseType) {
      VotingTimelinePhaseType.registration => context.l10n.votingTimelineVotingIn(duration),
      VotingTimelinePhaseType.voting => context.l10n.votingTimelineTallyIn(duration),
      VotingTimelinePhaseType.tally => context.l10n.votingTimelineResultsIn(duration),
      VotingTimelinePhaseType.results => context.l10n.votingTimelineNewFundComingSoon,
    };

    return Text(
      countdownText,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
  }

  String _formatDuration(BuildContext context, Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final d = context.l10n.durationDaysAbbreviation;
    final h = context.l10n.durationHoursAbbreviation;
    final m = context.l10n.durationMinutesAbbreviation;

    final buffer = StringBuffer();

    if (days > 0) {
      buffer.write('$days$d');
    }

    if (hours > 0 || days > 0) {
      if (buffer.isNotEmpty) {
        buffer.write(' ');
      }
      buffer.write('${hours.toString().padLeft(2, '0')}$h');
    }

    if (buffer.isNotEmpty) {
      buffer.write(' ');
    }

    buffer.write('${minutes.toString().padLeft(2, '0')}$m');

    return buffer.toString();
  }
}

class _VotingPowerSnapshot extends StatelessWidget {
  final DateTime? snapshotDate;

  const _VotingPowerSnapshot({
    required this.snapshotDate,
  });

  @override
  Widget build(BuildContext context) {
    final snapshotDate = this.snapshotDate;
    if (snapshotDate == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colors.textOnPrimaryLevel1,
      fontWeight: FontWeight.w500,
    );
    final formattedDate = DateFormatter.formatFullDate24Format(snapshotDate);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: context.l10n.votingTimelineVotingPowerSnapshot,
            style: textStyle?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: formattedDate,
            style: textStyle,
          ),
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: _UtcBadge(),
            ),
          ),
        ],
      ),
      style: textStyle,
    );
  }
}

class _VotingTimelineFooter extends StatelessWidget {
  final VotingTimelineDetailsViewModel viewModel;

  const _VotingTimelineFooter({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _VotingPowerSnapshot(
          snapshotDate: viewModel.snapshotDate,
        ),
        _Countdown(
          phaseType: viewModel.currentPhase.type,
          phaseEndsIn: viewModel.currentPhaseEndsIn,
        ),
      ],
    );
  }
}
