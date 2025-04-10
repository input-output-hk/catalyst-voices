import 'dart:async';

import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalsPaginationTile extends StatelessWidget {
  final ProposalViewModel proposal;

  const ProposalsPaginationTile({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, bool>(
      selector: (state) => state.isFavorite(proposal.ref.id),
      builder: (context, state) {
        return _ProposalsPaginationTile(
          proposal: proposal.copyWith(isFavorite: state),
        );
      },
    );
  }
}

class _ProposalsPaginationTile extends StatelessWidget {
  final ProposalViewModel proposal;

  const _ProposalsPaginationTile({
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    return ProposalCard(
      proposal: proposal,
      isFavorite: proposal.isFavorite,
      onTap: () {
        final route = ProposalRoute.fromRef(ref: proposal.ref);

        unawaited(route.push(context));
      },
      onFavoriteChanged: (isFavorite) {
        context.read<ProposalsCubit>().onChangeFavoriteProposal(
              proposal.ref,
              isFavorite: isFavorite,
            );
      },
    );
  }
}
