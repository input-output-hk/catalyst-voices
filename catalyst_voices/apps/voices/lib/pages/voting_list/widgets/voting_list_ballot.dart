import 'dart:async';

import 'package:catalyst_voices/pages/voting_list/widgets/voting_list_tile.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingListBallot extends StatelessWidget {
  const VotingListBallot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VotingBallotBloc, VotingBallotState, List<VotingListTileData>>(
      selector: (state) => state.tiles,
      builder: (context, state) {
        return _VotingListBallot(items: state);
      },
    );
  }
}

class _VotingListBallot extends StatelessWidget {
  final List<VotingListTileData> items;

  const _VotingListBallot({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _VotingListBallotEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return VotingListTile(
          key: ValueKey('Category${index}TileKey'),
          data: item,
          onProposalTap: (value) {
            final route = ProposalRoute.fromRef(ref: value);

            unawaited(route.push(context));
          },
          onVoteChanged: (value) {
            final proposal = value.proposal;
            final event = switch (value.action) {
              VoteButtonActionRemoveDraft() => RemoveVoteEvent(proposal: proposal),
              VoteButtonActionVote(:final type) => UpdateVoteEvent(proposal: proposal, type: type),
            };

            context.read<VotingBallotBloc>().add(event);
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
    );
  }
}

class _VotingListBallotEmptyState extends StatelessWidget {
  const _VotingListBallotEmptyState();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.3),
      child: EmptyState(
        image: VoicesAssets.images.svg.noVotes.buildPicture(),
        title: Text(_buildTitleParts(context).join('\n')),
        constraints: const BoxConstraints(maxWidth: 236),
      ),
    );
  }

  List<String> _buildTitleParts(BuildContext context) {
    return [
      context.l10n.votingListNoVotesAdded,
      context.l10n.votingListNoVotesAddedViewProposal,
    ];
  }
}
