import 'dart:async';

import 'package:catalyst_voices_blocs/src/proposals/proposals_state.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the proposals.
final class ProposalsCubit extends Cubit<ProposalsState> {
  final ProposalRepository proposalRepository;

  ProposalsCubit({required this.proposalRepository})
      : super(const LoadingProposalsState());

  /// Loads the proposals.
  Future<void> load() async {
    const currentCampaignId = 'f14';

    final proposals = await proposalRepository.getDraftProposals(
      campaignId: currentCampaignId,
    );

    final pendingProposals = proposals.map(
      (proposal) {
        return PendingProposal.fromProposal(
          proposal,
          campaignName: 'F14',
        );
      },
    ).toList();

    emit(
      LoadedProposalsState(
        proposals: pendingProposals,
        favoriteProposals: const [],
      ),
    );
  }

  /// Marks the proposal with [proposalId] as favorite.
  Future<void> onFavoriteProposal(String proposalId) async {
    final loadedState = state;
    if (loadedState is! LoadedProposalsState) return;

    final proposals = loadedState.proposals;
    final favoriteProposal =
        proposals.firstWhereOrNull((e) => e.id == proposalId);
    if (favoriteProposal == null) return;

    emit(
      LoadedProposalsState(
        proposals: loadedState.proposals,
        favoriteProposals: [
          ...loadedState.favoriteProposals,
          favoriteProposal,
        ],
      ),
    );
  }

  /// Unmarks the proposal with [proposalId] as favorite.
  Future<void> onUnfavoriteProposal(String proposalId) async {
    final loadedState = state;
    if (loadedState is! LoadedProposalsState) return;

    emit(
      LoadedProposalsState(
        proposals: loadedState.proposals,
        favoriteProposals: loadedState.favoriteProposals
            .whereNot((e) => e.id == proposalId)
            .toList(),
      ),
    );
  }
}
