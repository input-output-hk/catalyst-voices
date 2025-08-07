import 'dart:async';

import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/cards/proposal/proposal_brief_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingProposalsPaginationTile extends StatelessWidget {
  final ProposalBriefVoting proposal;

  const VotingProposalsPaginationTile({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    return ProposalBriefCard(
      proposal: proposal,
      onTap: () {
        final route = ProposalRoute.fromRef(ref: proposal.selfRef);

        unawaited(route.push(context));
      },
      onFavoriteChanged: (isFavorite) {
        context.read<VotingCubit>().onChangeFavoriteProposal(
              proposal.selfRef,
              isFavorite: isFavorite,
            );
      },
      onVoteAction: (action) {
        final proposal = this.proposal.selfRef;
        final event = switch (action) {
          VoteButtonActionRemoveDraft() => RemoveVoteEvent(proposal: proposal),
          VoteButtonActionVote(:final type) => UpdateVoteEvent(proposal: proposal, type: type),
        };

        context.read<VotingBallotBloc>().add(event);
      },
    );
  }
}
