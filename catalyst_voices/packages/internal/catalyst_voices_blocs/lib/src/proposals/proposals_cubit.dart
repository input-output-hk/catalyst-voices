import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the proposals.
final class ProposalsCubit extends Cubit<ProposalsState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  ProposalsCubit(
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalsState(isLoading: true));

  /// Loads the proposals.
  Future<void> load({
    int pageKey = 0,
    int pageSize = 24,
    String? lastProposalId,
    String? categoryId,
    String? searchValue,
  }) async {
    await Future.delayed(const Duration(seconds: 1), () {});
    final campaign = await _campaignService.getActiveCampaign();
    if (campaign == null) {
      return;
    }

    final proposals = await _loadRegularProposals(
      campaignId: campaign.id,
      campaignName: campaign.name,
      campaignStage: CampaignStage.fromCampaign(campaign, DateTimeExt.now()),
    );
    proposals.proposals.shuffle();
    emit(
      state.copyWith(
        proposals: proposals.copyWith(
          proposals: state.proposals.proposals + proposals.proposals,
        ),
        isLoading: false,
        pageKey: pageKey,
      ),
    );
  }

  /// Changes the favorite status of the proposal with [proposalId].
  Future<void> onChangeFavoriteProposal(
    String proposalId, {
    required bool isFavorite,
  }) async {
    final proposals = List<ProposalViewModel>.of(state.proposals.proposals);
    final favoriteProposal = proposals.indexWhere((e) => e.id == proposalId);
    if (favoriteProposal == -1) return;
    proposals[favoriteProposal] =
        proposals[favoriteProposal].copyWith(isFavorite: isFavorite);

    // emit(
    //   LoadedProposalsState(
    //     proposals: proposals,
    //     resultsNumber: state.resultsNumber,
    //   ),
    // );
  }

  Future<ProposalSearchViewModel> _loadRegularProposals({
    required String campaignId,
    required String campaignName,
    required CampaignStage campaignStage,
  }) async {
    final proposals = await _proposalService.getProposals(
      campaignId: campaignId,
    );

    return ProposalSearchViewModel.fromModel(
      proposals,
      campaignName,
      campaignStage,
    );
  }

  void resetCurrentPage() {
    emit(state.copyWith(pageKey: 0));
    print('change page to 0');
  }
}
