import 'dart:async';

import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/cards/proposal/proposal_brief_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalsPaginationTile extends StatelessWidget {
  final ProposalBrief proposal;

  const ProposalsPaginationTile({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(dt-iohk): get rid of the selector, let ProposalsCubit emit state with
    // proposalBrief which already has the isFavorite set to correct value
    return BlocSelector<ProposalsCubit, ProposalsState, bool>(
      selector: (state) => state.isFavorite(proposal.selfRef.id),
      builder: (context, isFavorite) {
        return _ProposalsPaginationTile(
          proposal: proposal.copyWith(isFavorite: isFavorite),
        );
      },
    );
  }
}

class _ProposalsPaginationTile extends StatelessWidget {
  final ProposalBrief proposal;

  const _ProposalsPaginationTile({
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
        context.read<ProposalsCubit>().onChangeFavoriteProposal(
              proposal.selfRef,
              isFavorite: isFavorite,
            );
      },
    );
  }
}
