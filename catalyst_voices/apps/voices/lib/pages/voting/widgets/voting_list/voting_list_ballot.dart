import 'dart:math';

import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_tile.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListBallot extends StatelessWidget {
  const VotingListBallot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(damian-molinski): use selector
    final items = List.generate(
      5,
      (index) {
        return VotingListTileData(
          category: SignedDocumentRef.generateFirstRef(),
          categoryText: 'Category nr.${index + 1}',
          votes: List.generate(
            Random().nextInt(10),
            (index) {
              return VotingListTileVoteData(
                proposal: SignedDocumentRef.generateFirstRef(),
                proposalTitle: 'Proposal nr.${index + 1}',
                authorName: 'Author nr.${index + 1}',
                vote: VoteButtonData(
                  draft: VoteTypeDataDraft(
                    type: Random().nextBool() ? VoteType.yes : VoteType.abstain,
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    return _VotingListBallot(items: items);
  }
}

class _VotingListBallot extends StatelessWidget {
  final List<VotingListTileData> items;

  const _VotingListBallot({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return VotingListTile(
          key: ValueKey('Category${index}TileKey'),
          data: item,
          // TODO(damian-molinski): call VotingBallotBloc
          onProposalTap: (value) {},
          // TODO(damian-molinski): call VotingBallotBloc
          onVoteChanged: (value) {},
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }
}
