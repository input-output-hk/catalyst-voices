import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListVoteListTile extends StatelessWidget {
  const VotingListVoteListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesExpansionTile(
      title: _VotingListVoteListTileTitle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tilePadding: const EdgeInsets.all(16),
      childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      backgroundColor: context.colors.elevationsOnSurfaceNeutralLv1Grey,
      initiallyExpanded: true,
      children: [
        _VotingListVoteListTileVote(0),
        _VotingListVoteListTileVote(1),
        _VotingListVoteListTileVote(2),
      ],
    );
  }
}

class _VotingListVoteListTileTitle extends StatelessWidget {
  const _VotingListVoteListTileTitle();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        AffixDecorator(
          gap: 4,
          prefix: VoicesAssets.icons.viewGrid.buildIcon(
            size: 18,
            color: colors.iconsForeground,
          ),
          child: Text(
            'Cardano Use Cases: Concept',
            style: textTheme.titleSmall?.copyWith(color: colors.textOnPrimaryLevel0),
          ),
        ),
        Text(
          '3 Votes',
          style: textTheme.bodySmall?.copyWith(color: colors.textOnPrimaryLevel1),
        ),
      ],
    );
  }
}

class _VotingListVoteListTileVote extends StatelessWidget {
  final int index;

  const _VotingListVoteListTileVote(this.index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                  _VotingListVoteListTileVoteProposalTitleText(
                    'Blockchain-Based Microlending Platform for SMEs',
                  ),
                  _VotingListVoteListTileVoteProposalAuthorNameText('Tyler Durden'),
                ],
              ),
            ),
            VoteButton(
              data: VoteButtonData(draft: VoteTypeDataDraft(type: VoteType.yes)),
              onSelected: (value) {},
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _VotingListVoteListTileVoteProposalAuthorNameText extends StatelessWidget {
  final String data;

  const _VotingListVoteListTileVoteProposalAuthorNameText(this.data);

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

class _VotingListVoteListTileVoteProposalTitleText extends StatelessWidget {
  final String data;

  const _VotingListVoteListTileVoteProposalTitleText(this.data);

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
