part of 'voting_timeline_header.dart';

class _VotingTimelineProgressBar extends StatelessWidget {
  const _VotingTimelineProgressBar();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, double?>(
      selector: (state) => state.votingTimeline?.campaignProgress,
      builder: (context, progress) => _VotingTimelineProgressBarContent(progress: progress),
    );
  }
}

class _VotingTimelineProgressBarContent extends StatelessWidget {
  final double? progress;

  const _VotingTimelineProgressBarContent({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    if (progress == null) {
      return const SizedBox.shrink();
    }

    return VoicesLinearProgressIndicator(
      value: progress,
      weight: VoicesProgressIndicatorWeight.heavy,
    );
  }
}
