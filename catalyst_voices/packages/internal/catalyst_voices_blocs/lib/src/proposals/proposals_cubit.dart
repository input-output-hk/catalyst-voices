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
  final AdminTools _adminTools;

  AdminToolsState _adminToolsState;
  StreamSubscription<AdminToolsState>? _adminToolsSub;

  ProposalsCubit(
    this._campaignService,
    this._proposalService,
    this._adminTools,
  )   : _adminToolsState = _adminTools.state,
        super(const ProposalsState(isLoading: true)) {
    _adminToolsSub = _adminTools.stream.listen(_onAdminToolsChanged);
  }

  Future<void> init(String? categoryId) async {
    // TODO(LynxLynxx): get categories from repository.
    final categories = List.generate(
      6,
      (index) => CampaignCategoryViewModel.dummy(id: '$index'),
    );
    emit(
      state.copyWith(
        categories: categories,
        selectedCategory:
            categories.firstWhereOrNull((e) => e.id == categoryId),
        isLoading: false,
      ),
    );
  }

  void changeSelectedCategory(String? categoryId) {
    if (categoryId == null) {
      return emit(state.copyWith(selectedCategory: null));
    }
    final selectedCategory =
        state.categories.firstWhereOrNull((e) => e.id == categoryId);

    emit(state.copyWith(selectedCategory: selectedCategory));
  }

  /// Loads the proposals.
  Future<void> load() async {
    emit(state.copyWith(isLoading: true));

    final campaign = await _campaignService.getActiveCampaign();
    if (campaign == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final proposals = await _loadProposals(campaign);
    emit(
      state.copyWith(
        proposals: proposals,
        isLoading: false,
      ),
    );
  }

  /// Changes the favorite status of the proposal with [proposalId].
  Future<void> onChangeFavoriteProposal(
    String proposalId, {
    required bool isFavorite,
  }) async {
    final proposals = List<ProposalViewModel>.of(state.proposals);
    final favoriteProposal = proposals.indexWhere((e) => e.id == proposalId);
    if (favoriteProposal == -1) return;
    proposals[favoriteProposal] =
        proposals[favoriteProposal].copyWith(isFavorite: isFavorite);

    emit(
      state.copyWith(
        proposals: proposals,
        isLoading: false,
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
