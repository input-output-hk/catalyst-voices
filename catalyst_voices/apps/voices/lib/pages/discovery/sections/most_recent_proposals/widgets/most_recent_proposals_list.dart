import 'dart:async';

import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class MostRecentProposalsList extends StatelessWidget {
  final ScrollController? scrollController;

  const MostRecentProposalsList({
    super.key,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, DiscoveryMostRecentProposalsState>(
      selector: (state) => state.proposals,
      builder: (context, state) {
        return _MostRecentProposalsList(
          scrollController: scrollController,
          proposals: state.proposals,
        );
      },
    );
  }
}

class _MostRecentProposalsList extends StatelessWidget {
  final List<ProposalBrief> proposals;
  final ScrollController? scrollController;

  const _MostRecentProposalsList({
    required this.proposals,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        final proposal = proposals[index];
        final id = proposal.id;
        return Padding(
          key: Key('PendingProposalCard_$id'),
          padding: EdgeInsets.only(right: index < proposals.length - 1 ? 12 : 0),
          child: ProposalBriefCard(
            proposal: proposal,
            onTap: () => _onCardTap(context, id),
            onFavoriteChanged: (value) => _onCardFavoriteChanged(context, id, value),
          ),
        );
      },
      prototypeItem: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ProposalBriefCard(proposal: ProposalBrief.prototype()),
      ),
    );
  }

  Future<void> _onCardFavoriteChanged(
    BuildContext context,
    DocumentRef id,
    bool isFavorite,
  ) async {
    final bloc = context.read<DiscoveryCubit>();
    if (isFavorite) {
      await bloc.addFavorite(id);
    } else {
      await bloc.removeFavorite(id);
    }
  }

  void _onCardTap(BuildContext context, DocumentRef id) {
    unawaited(ProposalRoute.fromRef(ref: id).push(context));
  }
}
