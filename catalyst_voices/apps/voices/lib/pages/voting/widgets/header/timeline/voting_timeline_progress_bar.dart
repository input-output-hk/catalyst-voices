part of 'voting_timeline_header.dart';

class _VotingTimelineProgressBar extends StatelessWidget {
  final double progress;

  const _VotingTimelineProgressBar({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesLinearProgressIndicator(
      value: progress,
      weight: VoicesProgressIndicatorWeight.heavy,
    );
  }
}
