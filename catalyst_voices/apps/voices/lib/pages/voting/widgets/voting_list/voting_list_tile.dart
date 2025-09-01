import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

typedef VotingListTileVoteChange = ({DocumentRef proposal, VoteButtonAction action});

class VotingListTile extends StatelessWidget {
  final VotingListTileData data;
  final ValueChanged<DocumentRef> onProposalTap;
  final ValueChanged<VotingListTileVoteChange> onVoteChanged;

  const VotingListTile({
    super.key,
    required this.data,
    required this.onProposalTap,
    required this.onVoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesExpansionTile(
      title: _VotingListTileTitle(
        categoryText: data.categoryText,
        votesCount: data.votesCount,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tilePadding: const EdgeInsets.all(16),
      childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      backgroundColor: context.colors.elevationsOnSurfaceNeutralLv1Grey,
      initiallyExpanded: true,
      children: data.votes.map((vote) {
        return _VotingListTileVoteTile(
          vote,
          key: ValueKey('VoteOnProposal(${vote.proposal})TileKey'),
          onTap: () => onProposalTap(vote.proposal),
          onChanged: (value) => onVoteChanged((proposal: vote.proposal, action: value)),
        );
      }).toList(),
    );
  }
}

class _VotingListTileTitle extends StatelessWidget {
  final String categoryText;
  final int votesCount;

  const _VotingListTileTitle({
    required this.categoryText,
    required this.votesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        _VotingListTileTitleCategoryText(categoryText),
        _VotingListTileTitleVotesCountText(votesCount),
      ],
    );
  }
}

class _VotingListTileTitleCategoryText extends StatelessWidget {
  final String data;

  const _VotingListTileTitleCategoryText(this.data);

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.titleSmall ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return AffixDecorator(
      gap: 4,
      prefix: VoicesAssets.icons.viewGrid.buildIcon(
        size: 18,
        color: context.colors.iconsForeground,
      ),
      child: Text(
        data,
        style: textStyle,
      ),
    );
  }
}

class _VotingListTileTitleVotesCountText extends StatelessWidget {
  final int count;

  const _VotingListTileTitleVotesCountText(this.count);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.xVotes(count),
      style: context.textTheme.bodySmall?.copyWith(color: context.colors.textOnPrimaryLevel1),
    );
  }
}

class _VotingListTileVoteTile extends StatelessWidget {
  final VotingListTileVoteData data;
  final VoidCallback onTap;
  final ValueChanged<VoteButtonAction> onChanged;

  const _VotingListTileVoteTile(
    this.data, {
    super.key,
    required this.onTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          spacing: 32,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _VotingListTileVoteTileProposalTitleText(data.proposalTitle),
                  _VotingListTileVoteTileAuthorNameText(data.authorName),
                ],
              ),
            ),
            VoteButton(
              data: data.vote,
              onSelected: onChanged,
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _VotingListTileVoteTileAuthorNameText extends StatelessWidget {
  final String data;

  const _VotingListTileVoteTileAuthorNameText(this.data);

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel1,
    );

    return Text(
      data,
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _VotingListTileVoteTileProposalTitleText extends StatelessWidget {
  final String data;

  const _VotingListTileVoteTileProposalTitleText(this.data);

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: context.colors.textOnPrimaryLevel0,
    );

    return Text(
      data,
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
