part of 'vote_button.dart';

class _VoteButtonExpanded extends StatelessWidget {
  final VoteButtonData data;
  final ValueChanged<VoteButtonAction> onSelected;

  const _VoteButtonExpanded(
    this.data, {
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: _expandedWidth, height: 32),
      child: data.hasVoted
          ? _VoteButtonHasVoted(
              latestVote: data.votes.first,
              casted: data.casted,
              onChanged: onSelected,
            )
          : _VoteButtonNoVote(onSelected: (value) => onSelected(VoteButtonActionVote(value))),
    );
  }
}

class _VoteButtonHasVoted extends StatelessWidget {
  final VoteTypeData? latestVote;
  final VoteTypeDataCasted? casted;
  final ValueChanged<VoteButtonAction> onChanged;

  const _VoteButtonHasVoted({
    this.latestVote,
    this.casted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesRawPopupMenuButton<VoteButtonAction>(
      buttonBuilder: (context, onTapCallback, {required isMenuOpen}) {
        return _VoteButtonHasVotedButton(
          onTap: onTapCallback,
          voteType: latestVote?.type,
          votedAt: latestVote?.castedAt,
          inVoteList: latestVote?.isDraft ?? false,
        );
      },
      menuBuilder: (context) => _VoteButtonMenu(latest: latestVote, casted: casted),
      onSelected: onChanged,
      routeSettings: const RouteSettings(),
    );
  }
}

class _VoteButtonHasVotedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final VoteType? voteType;
  final DateTime? votedAt;
  final bool inVoteList;

  const _VoteButtonHasVotedButton({
    this.onTap,
    this.voteType,
    this.votedAt,
    this.inVoteList = false,
  });

  @override
  Widget build(BuildContext context) {
    final voteType = this.voteType;
    final votedAt = this.votedAt;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          ...<Widget>[
            if (voteType != null) Text(voteType.localisedName(context, present: inVoteList)),
            if (votedAt != null)
              TimestampText(
                votedAt,
                showTimezone: false,
                includeTime: false,
                style: DefaultTextStyle.of(context).style,
              ),
            if (inVoteList) const _VoteInVoteListText(),
          ].separatedBy(const Text('·')),
          VoicesAssets.icons.chevronDown.buildIcon(),
        ],
      ),
    );
  }
}

class _VoteButtonNoVote extends StatelessWidget {
  final ValueChanged<VoteType> onSelected;

  const _VoteButtonNoVote({
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _VoteButtonNoVoteYes(onTap: () => onSelected(VoteType.yes))),
        const VoicesVerticalDivider(width: 1),
        Expanded(child: _VoteButtonNoVoteAbstain(onTap: () => onSelected(VoteType.abstain))),
      ],
    );
  }
}

class _VoteButtonNoVoteAbstain extends StatelessWidget {
  final VoidCallback onTap;

  const _VoteButtonNoVoteAbstain({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _VoteButtonNoVoteChoice(
      voteType: VoteType.abstain,
      onTap: onTap,
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
    );
  }
}

class _VoteButtonNoVoteChoice extends StatelessWidget {
  final VoteType voteType;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  const _VoteButtonNoVoteChoice({
    required this.voteType,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            voteType.icon().buildIcon(),
            Text(voteType.localisedName(context)),
          ],
        ),
      ),
    );
  }
}

class _VoteButtonNoVoteYes extends StatelessWidget {
  final VoidCallback onTap;

  const _VoteButtonNoVoteYes({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _VoteButtonNoVoteChoice(
      voteType: VoteType.yes,
      onTap: onTap,
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
    );
  }
}

class _VoteInVoteListText extends StatelessWidget {
  const _VoteInVoteListText();

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.inVoteList);
  }
}
