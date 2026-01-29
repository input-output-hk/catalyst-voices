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
    final formattedEndsIn = DurationFormatter.formatDurationDDhhmm(context.l10n, phaseEndsIn);
    final text = phaseType.getCountdownLabel(context, duration: formattedEndsIn);

    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
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
          WidgetSpan(
            child: TimezoneDateTimeText(
              snapshotDate,
              formatter: (context, dateTime) => DateFormatter.formatFullDate24Format(dateTime),
              style: textStyle,
            ),
          ),
        ],
      ),
      style: textStyle,
    );
  }
}

class _VotingTimelineFooter extends StatelessWidget {
  const _VotingTimelineFooter();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingTimelineFooterViewModel?>(
      selector: (state) => state.votingTimeline?.footerViewModel,
      builder: (context, viewModel) => _VotingTimelineFooterContent(viewModel: viewModel),
    );
  }
}

class _VotingTimelineFooterContent extends StatelessWidget {
  final VotingTimelineFooterViewModel? viewModel;

  const _VotingTimelineFooterContent({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = this.viewModel;
    if (viewModel == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _VotingPowerSnapshot(snapshotDate: viewModel.snapshotDate),
        _Countdown(
          phaseType: viewModel.phaseType,
          phaseEndsIn: viewModel.phaseEndsIn,
        ),
      ],
    );
  }
}
