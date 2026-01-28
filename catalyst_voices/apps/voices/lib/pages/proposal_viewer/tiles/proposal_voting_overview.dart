import 'package:catalyst_voices/pages/document_viewer/widgets/document_favorite_button.dart';
import 'package:catalyst_voices/pages/document_viewer/widgets/document_share_button.dart';
import 'package:catalyst_voices/widgets/voting/vote_button.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalVotingOverview extends StatelessWidget {
  final ProposalViewVoting data;

  const ProposalVotingOverview(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 16,
        spacing: 8,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              DocumentShareButton(),
              DocumentFavoriteButton(),
            ],
          ),
          VoteButton(
            onSelected: (action) {
              final proposal = data.proposalRef;
              final event = switch (action) {
                VoteButtonActionRemoveDraft() => RemoveVoteEvent(proposal: proposal),
                VoteButtonActionVote(:final type) => UpdateVoteEvent(
                  proposal: proposal,
                  type: type,
                ),
              };

              context.read<VotingBallotBloc>().add(event);
            },
            data: data.voteButtonData,
          ),
        ],
      ),
    );
  }
}
