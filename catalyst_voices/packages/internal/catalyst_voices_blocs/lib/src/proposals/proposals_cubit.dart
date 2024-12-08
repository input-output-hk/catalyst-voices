import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the proposals.
final class ProposalsCubit extends Cubit<ProposalsState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final AdminToolsCubit _adminToolsCubit;

  AdminToolsState _adminToolsState;
  StreamSubscription<AdminToolsState>? _adminToolsSub;

  ProposalsCubit(
    this._campaignService,
    this._proposalService,
    this._adminToolsCubit,
  )   : _adminToolsState = _adminToolsCubit.state,
        super(const LoadingProposalsState()) {
    _adminToolsSub = _adminToolsCubit.stream.listen(_onAdminToolsChanged);
  }

  /// Loads the proposals.
  Future<void> load() async {
    emit(const LoadingProposalsState());

    final campaign = await _campaignService.getActiveCampaign();
    if (campaign == null) {
      emit(const LoadedProposalsState());
      return;
    }

    final proposals = await _loadProposals(campaign);
    emit(
      LoadedProposalsState(
        proposals: proposals,
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

  @override
  Future<void> close() async {
    await _adminToolsSub?.cancel();
    _adminToolsSub = null;

    return super.close();
  }

  Future<void> _onAdminToolsChanged(AdminToolsState adminTools) async {
    _adminToolsState = adminTools;
    await load();
  }

  Future<List<ProposalViewModel>> _loadProposals(Campaign campaign) {
    if (_adminToolsState.enabled) {
      return _loadMockedProposals(campaign);
    } else {
      return _loadRegularProposals(
        campaignId: campaign.id,
        campaignName: campaign.name,
        campaignStage: CampaignStage.fromCampaign(campaign, DateTimeExt.now()),
      );
    }
  }

  Future<List<ProposalViewModel>> _loadMockedProposals(
    Campaign campaign,
  ) async {
    switch (_adminToolsState.campaignStage) {
      case CampaignStage.draft:
      case CampaignStage.scheduled:
        // no proposals yet at this stage
        return [];
      case CampaignStage.live:
      case CampaignStage.completed:
        return _loadRegularProposals(
          campaignId: campaign.id,
          campaignName: campaign.name,
          campaignStage: _adminToolsState.campaignStage,
        );
    }
  }

  Future<List<ProposalViewModel>> _loadRegularProposals({
    required String campaignId,
    required String campaignName,
    required CampaignStage campaignStage,
  }) async {
    final proposals = await _proposalService.getProposals(
      campaignId: campaignId,
    );

    return proposals
        .map(
          (proposal) => ProposalViewModel.fromProposalAtStage(
            proposal: proposal,
            campaignName: campaignName,
            campaignStage: campaignStage,
          ),
        )
        .toList();
  }
}
