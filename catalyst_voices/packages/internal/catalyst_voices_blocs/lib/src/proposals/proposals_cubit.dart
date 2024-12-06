import 'dart:async';

import 'package:catalyst_voices_blocs/src/proposals/proposals_state.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the proposals.
final class ProposalsCubit extends Cubit<ProposalsState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  ProposalsCubit(
    this._campaignService,
    this._proposalService,
  ) : super(const LoadingProposalsState());

  /// Loads the proposals.
  Future<void> load() async {
    emit(const LoadingProposalsState());

    final campaign = await _campaignService.getActiveCampaign();
    if (campaign == null) {
      emit(
        const LoadedProposalsState(
          proposals: [],
          favoriteProposals: [],
        ),
      );
      return;
    }

    final proposals = await _proposalService.getProposals(
      campaignId: campaign.id,
    );

    final pendingProposals = proposals.map(
      (proposal) {
        return PendingProposal.fromProposal(
          proposal,
          campaignName: campaign.name,
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
