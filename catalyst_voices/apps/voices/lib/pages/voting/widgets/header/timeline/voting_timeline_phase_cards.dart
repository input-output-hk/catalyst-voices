part of 'voting_timeline_header.dart';

class _VotingTimelinePhaseCards extends StatelessWidget {
  const _VotingTimelinePhaseCards();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingCubit, VotingState, VotingTimelinePhasesViewModel?>(
      selector: (state) => state.votingTimeline?.phasesViewModel,
      builder: (context, viewModel) => _VotingTimelinePhaseCardsContent(viewModel: viewModel),
    );
  }
}

class _VotingTimelinePhaseCardsContent extends StatelessWidget {
  static const double _minCardWidth = 328;
  static const double _cardHeight = 271;
  static const double _spacing = 16;

  final VotingTimelinePhasesViewModel? viewModel;

  const _VotingTimelinePhaseCardsContent({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = this.viewModel;
    if (viewModel == null || viewModel.phases.isEmpty) {
      return const SizedBox.shrink();
    }

    final phases = viewModel.phases;
    final isVotingDelegated = viewModel.isVotingDelegated;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final cardCount = phases.length;

          // availableWidth = n * cardWidth + (n-1) * spacing
          // availableWidth = n * cardWidth + n * spacing - spacing
          // availableWidth + spacing = n * (cardWidth + spacing)
          // n = (availableWidth + spacing) / (cardWidth + spacing)
          final cardsPerRow = ((availableWidth + _spacing) / (_minCardWidth + _spacing))
              .floor()
              .clamp(1, cardCount);

          // availableWidth = cardsPerRow * cardWidth + (cardsPerRow - 1) * spacing
          // availableWidth - (cardsPerRow - 1) * spacing = cardsPerRow * cardWidth
          // cardWidth = (availableWidth - (cardsPerRow - 1) * spacing) / cardsPerRow
          final cardWidth = (availableWidth - ((cardsPerRow - 1) * _spacing)) / cardsPerRow;

          return Wrap(
            spacing: _spacing,
            runSpacing: _spacing,
            children: phases.map((phase) {
              return SizedBox(
                width: cardWidth,
                height: _cardHeight,
                child: _VotingTimelinePhaseCard(
                  phase: phase,
                  isVotingDelegated: isVotingDelegated,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
