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

class _VotingTimelinePhaseCardsContent extends StatefulWidget {
  final VotingTimelinePhasesViewModel? viewModel;

  const _VotingTimelinePhaseCardsContent({
    required this.viewModel,
  });

  @override
  State<_VotingTimelinePhaseCardsContent> createState() => _VotingTimelinePhaseCardsContentState();
}

class _VotingTimelinePhaseCardsContentState extends State<_VotingTimelinePhaseCardsContent> {
  static const _minCardWidth = 328.0;
  static const _cardHeight = 271.0;
  static const _spacing = 16.0;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    if (viewModel == null || viewModel.phases.isEmpty) {
      return const SizedBox.shrink();
    }

    final phases = viewModel.phases;
    final isVotingDelegated = viewModel.isVotingDelegated;
    final cardCount = phases.length;

    // Minimum width needed for all cards without scrolling
    final minRequiredWidth = (cardCount * _minCardWidth) + ((cardCount - 1) * _spacing);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;

          // If enough space - expand cards equally, otherwise use min width
          final cardWidth = availableWidth < minRequiredWidth
              ? _minCardWidth
              : (availableWidth - ((cardCount - 1) * _spacing)) / cardCount;

          return GestureDetector(
            onHorizontalDragUpdate: _handleHorizontalScroll,
            behavior: HitTestBehavior.translucent,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: _spacing,
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleHorizontalScroll(DragUpdateDetails details) {
    _scrollController.jumpTo(_scrollController.offset - details.delta.dx);
  }
}
