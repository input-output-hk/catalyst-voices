part of 'voting_timeline_header.dart';

class _Countdown extends StatelessWidget {
  final VotingTimelineFooterCountdownEvent data;

  const _Countdown({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDuration = DurationFormatter.formatDurationDDhhmm(context.l10n, data.duration);
    final text = data.phaseType.getCountdownLabel(context, duration: formattedDuration);

    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colors.textOnPrimaryLevel0,
      ),
    );
  }
}

class _FooterEvent extends StatelessWidget {
  final VotingTimelineFooterEvent? event;

  const _FooterEvent({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return switch (event) {
      final VotingTimelineFooterPowerSnapshotEvent event => _VotingPowerSnapshot(data: event),
      final VotingTimelineFooterCountdownEvent event => _Countdown(data: event),
      null => const SizedBox.shrink(),
    };
  }
}

class _VotingPowerSnapshot extends StatelessWidget {
  final VotingTimelineFooterPowerSnapshotEvent data;

  const _VotingPowerSnapshot({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
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
              data.date,
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
        _FooterEvent(event: viewModel.leftEvent),
        _FooterEvent(event: viewModel.rightEvent),
      ],
    );
  }
}
