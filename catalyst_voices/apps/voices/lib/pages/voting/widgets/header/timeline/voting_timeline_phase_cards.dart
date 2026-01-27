part of 'voting_timeline_header.dart';

class _VotingTimelinePhaseCards extends StatelessWidget {
  static const double _minCardWidth = 328;
  static const double _cardHeight = 271;
  static const double _spacing = 16;

  final List<VotingTimelinePhaseViewModel> phases;

  const _VotingTimelinePhaseCards({
    required this.phases,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
              child: _VotingTimelinePhaseCard(phase: phase),
            );
          }).toList(),
        );
      },
    );
  }
}
