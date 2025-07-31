import 'package:catalyst_voices/pages/voting/widgets/voting_list/voting_list_vote_list_tile.dart';
import 'package:flutter/material.dart';

class VotingListBallot extends StatelessWidget {
  const VotingListBallot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 20,
      itemBuilder: (context, index) {
        return VotingListVoteListTile(
          key: ValueKey('Category${index}TileKey'),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }
}
