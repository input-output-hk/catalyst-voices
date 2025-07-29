part of 'vote_button.dart';

class _VoteButtonCompact extends StatelessWidget {
  final VoteButtonData data;
  final ValueChanged<VoteButtonAction> onSelected;

  const _VoteButtonCompact(
    this.data, {
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final latestVote = data.votes.firstOrNull;

    return Tooltip(
      waitDuration: const Duration(milliseconds: 400),
      exitDuration: Duration.zero,
      enableTapToDismiss: false,
      richMessage: WidgetSpan(
        child: _VoteButtonMenu(
          latest: latestVote,
          casted: data.casted,
          onSelected: (value) {
            Tooltip.dismissAllToolTips();
            onSelected(value);
          },
        ),
      ),
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Text(
            latestVote?.type.localisedName(context, present: latestVote.isDraft) ?? '--',
          ),
        ),
      ),
    );
  }
}
