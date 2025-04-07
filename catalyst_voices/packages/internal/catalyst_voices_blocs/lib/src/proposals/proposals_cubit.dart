import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/proposals/proposals_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalsCubit');

/// Manages the proposals.
final class ProposalsCubit extends Cubit<ProposalsState>
    with BlocSignalEmitterMixin<ProposalsSignal, ProposalsState> {
  final UserService _userService;
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  ProposalsCubitCache _cache = const ProposalsCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<List<String>>? _favouriteProposalsIdsSub;
  StreamSubscription<ProposalsFiltersCount>? _proposalsCountSub;

  ProposalsCubit(
    this._userService,
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalsState()) {
    final activeAccount = _userService.user.activeAccount;
    final filters = ProposalsFilters(author: activeAccount?.catalystId);
    _cache = _cache.copyWith(filters: filters);

    _activeAccountIdSub = _userService.watchUser
        .map((event) => event.activeAccount?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);

    _favouriteProposalsIdsSub = _favouriteProposalsIdsSub = _proposalService
        .watchFavoritesProposalsIds()
        .distinct(listEquals)
        .listen(_handleFavouriteProposalsIds);
  }

  void changeFilters({
    Optional<CatalystId>? author,
    Optional<bool>? onlyMy,
    Optional<SignedDocumentRef>? category,
    ProposalsFilterType? type,
    Optional<String>? searchQuery,
  }) {
    final filters = _cache.filters.copyWith(
      type: type,
      author: author,
      onlyAuthor: onlyMy,
      category: category,
      searchQuery: searchQuery,
    );

    _cache = _cache.copyWith(filters: filters);

    _logger.finer('Filters changed to $filters');

    if (category != null) _rebuildCategories();

    _watchProposalsCount(filters: filters);

    emitSignal(const ResetProposalsPaginationSignal());
  }

  void changeSelectedCategory(SignedDocumentRef? categoryId) {
    emitSignal(ChangeCategorySignal(to: categoryId));
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _favouriteProposalsIdsSub?.cancel();
    _favouriteProposalsIdsSub = null;

    await _proposalsCountSub?.cancel();
    _proposalsCountSub = null;

    return super.close();
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

      final filters = _cache.filters;

      _logger.finer('Requesting page[$request] with [$filters]');

      final page = await _proposalService.getProposalsPage(
        request: request,
        filters: filters,
      );

      final proposals = page.items.map(
        (proposal) {
          return ProposalViewModel.fromProposalAtStage(
            proposal: proposal,
            campaignName: campaign.name,
            campaignStage: campaignStage,
          );
        },
      ).toList();

      final proposalsPagination = ProposalPaginationItems(
        pageKey: page.pageKey,
        maxResults: page.maxResults,
        items: proposals,
      );

      emit(state.copyWith(proposals: proposalsPagination));
    } catch (error, stackTrace) {
      _logger.severe('Failed loading page $request', error, stackTrace);
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

    changeFilters(
      onlyMy: Optional(onlyMyProposals),
      category: Optional(category),
      type: type,
    );
  }

  /// Changes the favorite status of the proposal with [ref].
  void onChangeFavoriteProposal(
    DocumentRef ref, {
    required bool isFavorite,
  }) {
    final favoritesIds = List.of(state.favoritesIds);

    if (isFavorite) {
      favoritesIds.add(ref.id);
    } else {
      favoritesIds.removeWhere((element) => element == ref.id);
    }

    emit(state.copyWith(favoritesIds: favoritesIds));

    if (isFavorite) {
      unawaited(_proposalService.addFavoriteProposal(ref: ref));
    } else {
      unawaited(_proposalService.removeFavoriteProposal(ref: ref));
    }
  }

  void updateSearchQuery(String query) {
    final asOptional =
        query.isEmpty ? const Optional<String>.empty() : Optional(query);

    if (asOptional.data == _cache.filters.searchQuery) {
      return;
    }

    changeFilters(searchQuery: asOptional);

    emit(state.copyWith(hasSearchQuery: !asOptional.isEmpty));
  }

  void _handleActiveAccountIdChange(CatalystId? id) {
    changeFilters(author: Optional(id));
  }

  void _handleFavouriteProposalsIds(List<String> ids) {
    emit(state.copyWith(favoritesIds: ids));
  }

  void _handleProposalsCount(ProposalsFiltersCount count) {
    _cache = _cache.copyWith(count: count);

    final typeCount = ProposalsTypeCount(
      total: count.countOf(type: ProposalsFilterType.total),
      drafts: count.countOf(type: ProposalsFilterType.drafts),
      finals: count.countOf(type: ProposalsFilterType.finals),
      favorites: count.countOf(type: ProposalsFilterType.favorites),
      my: count.countOf(type: ProposalsFilterType.my),
    );

    emit(state.copyWith(count: typeCount));
  }

  Future<void> _loadCampaignCategories() async {
    final categories = await _campaignService.getCampaignCategories();

    _cache = _cache.copyWith(categories: Optional(categories));

    if (!isClosed) {
      _rebuildCategories();
    }
  }

  void _rebuildCategories() {
    final selectedCategory = _cache.filters.category;
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

  void _watchProposalsCount({
    required ProposalsFilters filters,
  }) {
    unawaited(_proposalsCountSub?.cancel());
    _proposalsCountSub = _proposalService
        .watchProposalsCount(filters: filters)
        .distinct()
        .listen(_handleProposalsCount);
  }
}
