import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/proposals/proposals_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalsCubit');

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
    required ProposalsFilterType type,
  }) {
    _cache = _cache.copyWith(
      onlyMy: Optional(onlyMy),
      selectedCategory: Optional(category),
      type: Optional(type),
    );
    _rebuildCategories();
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

  Future<void> getProposals(PaginationPage<String?> request) async {
    try {
      emit(state.copyWithLoadingProposals(isLoading: true));

      await Future<void>.delayed(const Duration(seconds: 1));

      final campaign = await _campaignService.getActiveCampaign();
      if (campaign == null) {
        return;
      }

      final campaignStage = CampaignStage.fromCampaign(
        campaign,
        DateTimeExt.now(),
      );

      // TODO(damian-molinski): build add pass current filters.
      final proposals = await _proposalService.getProposals(
        request: request,
      );

      final proposalsViewModels = proposals.items.map(
        (proposal) {
          // TODO(damian-molinski): handle isFavorite rebuilds.
          return ProposalViewModel.fromProposalAtStage(
            proposal: proposal,
            campaignName: campaign.name,
            campaignStage: campaignStage,
          );
        },
      ).toList();

      final proposalsPagination = ProposalPaginationItems(
        pageKey: proposals.pageKey,
        maxResults: proposals.maxResults,
        items: proposalsViewModels,
      );

      emit(state.copyWith(proposals: proposalsPagination));
    } catch (error, stackTrace) {
      _logger.severe('Failed loading proposals $request', error, stackTrace);
    } finally {
      emit(state.copyWithLoadingProposals(isLoading: false));
    }
  }

  void init({
    required bool onlyMyProposals,
    required SignedDocumentRef? category,
    required ProposalsFilterType type,
  }) {
    _cache = const ProposalsCubitCache();

    unawaited(_loadCampaignCategories());
    changeFilters(onlyMy: onlyMyProposals, category: category, type: type);
  }

  /// Changes the favorite status of the proposal with [ref].
  Future<void> onChangeFavoriteProposal(
    DocumentRef ref, {
    required bool isFavorite,
  }) async {
    /*if (isFavorite) {
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
    }*/
  }

  // TODO(LynxLynxx): to mock data. remove after implementing db
  Future<void> _favorite(
    bool isFavorite,
    ProposalViewModel proposal,
  ) async {
    /*final favoritesProposals = state.favoriteProposals;

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
    }*/
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
      return ProposalsCategorySelectorItem(
        ref: e.selfRef,
        name: e.categoryText,
        isSelected: e.selfRef.id == selectedCategory?.id,
      );
    }).toList();

    emit(state.copyWith(categorySelectorItems: categorySelectorItems));
  }
}
