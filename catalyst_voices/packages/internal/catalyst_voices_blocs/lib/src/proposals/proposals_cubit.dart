import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/proposals/proposals_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the proposals.
final class ProposalsCubit extends Cubit<ProposalsState>
    with BlocSignalEmitterMixin<ProposalsSignal, ProposalsState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  ProposalsCubitCache _cache = const ProposalsCubitCache();

  ProposalsCubit(
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalsState());

  void changeFilters({
    required bool? onlyMy,
    required SignedDocumentRef? category,
  }) {
    _cache = _cache.copyWith(
      onlyMy: Optional(onlyMy),
      selectedCategory: Optional(category),
    );
    _rebuildCategories();

    // TODO(damian-molinski): watch proposals
  }

  void changeSearchValue(String searchValue) {
    emit(
      state.copyWith(
        searchValue: searchValue.isEmpty
            ? const Optional.empty()
            : Optional(searchValue),
      ),
    );
  }

  void changeSelectedCategory(SignedDocumentRef? categoryId) {
    emitSignal(ChangeCategorySignal(to: categoryId));
  }

  Future<void> getFavoritesList() async {
    final favoritesList = await _proposalService.getFavoritesProposalsIds();

    if (!isClosed) {
      emit(state.copyWith(favoritesIds: favoritesList));
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
      return _emitUserProposals(
        proposalViewModelList,
        proposals.pageKey,
        proposals.maxResults,
      );
    } else if (request.usersFavorite) {
      return _emitFavoriteProposals(
        proposalViewModelList,
        proposals.pageKey,
        proposals.maxResults,
      );
    } else if (request.stage == ProposalPublish.submittedProposal) {
      return _emitFinalProposals(
        proposalViewModelList,
        proposals.pageKey,
        proposals.maxResults,
      );
    } else if (request.stage == ProposalPublish.publishedDraft) {
      return _emitDraftProposals(
        proposalViewModelList,
        proposals.pageKey,
        proposals.maxResults,
      );
    } else {
      return _emitAllProposals(
        proposalViewModelList,
        proposals.pageKey,
        proposals.maxResults,
      );
    }
  }

  Future<void> getUserProposalsList() async {
    // TODO(LynxLynxx): pass user id? or we read it inside of the service?
    final favoritesList = await _proposalService.getUserProposalsIds('');

    emit(state.copyWith(favoritesIds: favoritesList));
  }

  void init({
    required bool onlyMyProposals,
    required SignedDocumentRef? category,
  }) {
    _cache = const ProposalsCubitCache();

    unawaited(_loadCampaignCategories());
    changeFilters(onlyMy: onlyMyProposals, category: category);
  }

  /// Changes the favorite status of the proposal with [ref].
  Future<void> onChangeFavoriteProposal(
    DocumentRef ref, {
    required bool isFavorite,
  }) async {
    if (isFavorite) {
      // ignore: unused_local_variable
      final favIds = await _proposalService.addFavoriteProposal(ref: ref);
      // TODO(LynxLynxx): to mock data. remove after implementing db
      final favoritesIds = [...state.favoritesIds, ref.id];
      emit(state.copyWith(favoritesIds: favoritesIds));
      // TODO(LynxLynxx): to mock data. should read proposal from db and change
      // isFavorite
      // await _proposalService.getProposal(id: proposalId);

      // TODO(LynxLynxx): to mock data. remove after implementing db
      final proposal = state.allProposals.items.first.copyWith(
        ref: ref,
        isFavorite: isFavorite,
      );
      await _favorite(isFavorite, proposal);
    } else {
      // TODO(LynxLynxx): to mock data. remove after implementing db
      final proposal = state.allProposals.items.first.copyWith(
        ref: ref,
        isFavorite: isFavorite,
      );
      await _favorite(isFavorite, proposal);
      await _proposalService.removeFavoriteProposal(ref: ref);
      // TODO(LynxLynxx): to mock data. remove after implementing db
      final favoritesIds = [...state.favoritesIds]..remove(ref.id);

      emit(state.copyWith(favoritesIds: favoritesIds));
    }
  }

  void _emitAllProposals(
    List<ProposalViewModel> proposalViewModelList,
    int pageKey,
    int maxResults,
  ) {
    emit(state.allProposalsLoading);
    final allProposals = [
      ...state.allProposals.items,
      ...proposalViewModelList,
    ]..shuffled();
    return emit(
      state.copyWith(
        allProposals: state.allProposals.copyWith(
          pageKey: pageKey,
          maxResults: maxResults,
          items: allProposals,
        ),
      ),
    );
  }

  void _emitDraftProposals(
    List<ProposalViewModel> proposalViewModelList,
    int pageKey,
    int maxResults,
  ) {
    emit(state.draftProposalsLoading);
    final draftProposals = [
      ...state.draftProposals.items,
      ...proposalViewModelList,
    ];
    return emit(
      state.copyWith(
        draftProposals: state.draftProposals.copyWith(
          pageKey: pageKey,
          maxResults: maxResults,
          items: draftProposals,
        ),
      ),
    );
  }

  void _emitFavoriteProposals(
    List<ProposalViewModel> proposalViewModelList,
    int pageKey,
    int maxResults,
  ) {
    emit(state.favoriteProposalsLoading);
    final favorite = [
      ...state.favoriteProposals.items,
      ...proposalViewModelList,
    ];

    return emit(
      state.copyWith(
        favoriteProposals: state.favoriteProposals.copyWith(
          pageKey: pageKey,
          // TODO(LynxLynxx): change to maxResults when implementing db
          maxResults: favorite.length,
          items: favorite,
        ),
      ),
    );
  }

  void _emitFinalProposals(
    List<ProposalViewModel> proposalViewModelList,
    int pageKey,
    int maxResults,
  ) {
    emit(state.finalProposalsLoading);
    final finalProposals = [
      ...state.finalProposals.items,
      ...proposalViewModelList,
    ];
    return emit(
      state.copyWith(
        finalProposals: state.finalProposals.copyWith(
          pageKey: pageKey,
          maxResults: maxResults,
          items: finalProposals,
        ),
      ),
    );
  }

  void _emitUserProposals(
    List<ProposalViewModel> proposalViewModelList,
    int pageKey,
    int maxResults,
  ) {
    emit(state.userProposalsLoading);
    final userProposals = [
      ...state.userProposals.items,
      ...proposalViewModelList,
    ];
    return emit(
      state.copyWith(
        userProposals: state.userProposals.copyWith(
          pageKey: pageKey,
          // TODO(LynxLynxx): change to maxResults when implementing db
          maxResults: userProposals.length,
          items: userProposals,
        ),
      ),
    );
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
              ...state.favoriteProposals.items,
              proposal,
            ],
          ),
        ),
      );
    } else {
      final items = [...state.favoriteProposals.items]
        ..removeWhere((e) => e.ref == proposal.ref);
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

  Future<void> _loadCampaignCategories() async {
    final categories = await _campaignService.getCampaignCategories();

    _cache = _cache.copyWith(categories: Optional(categories));

    if (!isClosed) {
      _rebuildCategories();
    }
  }

  void _rebuildCategories() {
    final selectedCategory = _cache.selectedCategory;
    final categories = _cache.categories ?? const [];

    final categorySelectorItems = categories.map((e) {
      return ProposalsStateCategorySelectorItem(
        ref: e.selfRef,
        name: e.categoryName,
        isSelected: e.selfRef.id == selectedCategory?.id,
      );
    }).toList();

    emit(state.copyWith(categorySelectorItems: categorySelectorItems));
  }
}
