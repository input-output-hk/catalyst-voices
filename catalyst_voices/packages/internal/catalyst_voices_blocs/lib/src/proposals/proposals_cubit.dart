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

  ProposalsCubit(
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalsState());

  /// Changes the favorite status of the proposal with [proposalId].
  Future<void> onChangeFavoriteProposal(
    String proposalId, {
    required bool isFavorite,
  }) async {
    if (isFavorite) {
      // ignore: unused_local_variable
      final favIds = await _proposalService.addFavoriteProposal(proposalId);
      // TODO(LynxLynxx): to mock data. remove after implementing db
      final favoritesIds = [...state.favoritesIds, proposalId];
      emit(state.copyWith(favoritesIds: favoritesIds));

      // TODO(LynxLynxx): to mock data. remove after implementing db
      final proposal = state.allProposals.items.first.copyWith(id: proposalId);
      await _favorite(isFavorite, proposal);
    } else {
      await _proposalService.removeFavoriteProposal(proposalId);
      // TODO(LynxLynxx): to mock data. remove after implementing db
      final favoritesIds = [...state.favoritesIds]..remove(proposalId);
      emit(state.copyWith(favoritesIds: favoritesIds));
      // TODO(LynxLynxx): to mock data. remove after implementing db
      final proposal = state.allProposals.items.first.copyWith(id: proposalId);
      await _favorite(isFavorite, proposal);
    }
  }

  Future<void> getProposals(
    ProposalPaginationRequest request,
  ) async {
    final campaign = await _campaignService.getActiveCampaign();
    if (campaign == null) {
      return;
    }

    final proposals = await _proposalService.getProposals(
      request: request,
    );
    await Future.delayed(const Duration(seconds: 1), () {});

    final proposalViewModelList = proposals.items
        .map(
          (e) => ProposalViewModel.fromProposalAtStage(
            proposal: e,
            campaignName: campaign.name,
            campaignStage:
                CampaignStage.fromCampaign(campaign, DateTimeExt.now()),
          ),
        )
        .toList();

    if (request.usersProposals) {
      return emit(
        state.copyWith(
          userProposals: state.userProposals.copyWith(
            pageKey: proposals.pageKey,
            maxResults: proposals.maxResults,
            items: [
              ...state.userProposals.items,
              ...proposalViewModelList,
            ],
            isEmpty: proposalViewModelList.isEmpty,
          ),
        ),
      );
    } else if (request.usersFavorite) {
      return emit(
        state.copyWith(
          favoriteProposals: state.favoriteProposals.copyWith(
            pageKey: proposals.pageKey,
            maxResults: proposals.maxResults,
            items: [
              ...state.favoriteProposals.items,
              ...proposalViewModelList,
            ],
            isEmpty: proposalViewModelList.isEmpty,
          ),
        ),
      );
    } else if (request.stage == ProposalPublish.published) {
      return emit(
        state.copyWith(
          finalProposals: state.finalProposals.copyWith(
            pageKey: proposals.pageKey,
            maxResults: proposals.maxResults,
            items: [
              ...state.finalProposals.items,
              ...proposalViewModelList,
            ],
            isEmpty: proposalViewModelList.isEmpty,
          ),
        ),
      );
    } else if (request.stage == ProposalPublish.draft) {
      return emit(
        state.copyWith(
          draftProposals: state.draftProposals.copyWith(
            pageKey: proposals.pageKey,
            maxResults: proposals.maxResults,
            items: [
              ...state.draftProposals.items,
              ...proposalViewModelList,
            ],
            isEmpty: proposalViewModelList.isEmpty,
          ),
        ),
      );
    } else {
      final allProposals = [
        ...state.allProposals.items,
        ...proposalViewModelList,
      ]..shuffled();
      return emit(
        state.copyWith(
          allProposals: state.allProposals.copyWith(
            pageKey: proposals.pageKey,
            maxResults: proposals.maxResults,
            items: allProposals,
            isEmpty: proposalViewModelList.isEmpty,
          ),
        ),
      );
    }
  }

  Future<void> getFavoritesList() async {
    final favoritesList = await _proposalService.getFavoritesProposalsIds();

    emit(state.copyWith(favoritesIds: favoritesList));
  }

  Future<void> getUserProposalsList() async {
    // TODO(LynxLynxx): pass user id? or we read it inside of the service?
    final favoritesList = await _proposalService.getUserProposalsIds('');

    emit(state.copyWith(favoritesIds: favoritesList));
  }

  Future<void> getCampaignCategories() async {
    await _campaignService.getCampaignCategories();
    final categories = List.generate(
      6,
      (index) => CampaignCategoryViewModel.dummy(id: '$index'),
    );

    emit(state.copyWith(categories: categories));
  }

  void changeSelectedCategory(String? categoryId) {
    emit(state.copyWith(selectedCategoryId: Optional(categoryId)));
  }

  // TODO(LynxLynxx): to mock data. remove after implementing db
  Future<void> _favorite(
    bool isFavorite,
    ProposalViewModel proposal,
  ) async {
    final favoritesProposals = state.favoriteProposals;

    if (isFavorite) {
      emit(
        state.copyWith(
          favoriteProposals: favoritesProposals.copyWith(
            pageKey: 0,
            maxResults: state.favoritesIds.length,
            items: [
              proposal,
              ...state.favoriteProposals.items,
            ],
          ),
        ),
      );
    } else {
      final items = [...state.favoriteProposals.items]..remove(proposal);
      emit(
        state.copyWith(
          favoriteProposals: favoritesProposals.copyWith(
            pageKey: 0,
            maxResults: state.favoritesIds.length,
            items: items,
          ),
        ),
      );
    }
  }
}
