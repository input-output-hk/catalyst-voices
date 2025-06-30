import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/proposals/proposals_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

const _recentProposalsMaxAge = Duration(hours: 72);
final _logger = Logger('ProposalsCubit');

/// Manages the proposals.
///
/// This Cubit has [ProposalsCubitCache] to store the data which allows to reduce
/// the number of calls to the services.
///
/// Allows to get paginated proposals based on the filters and order.
final class ProposalsCubit extends Cubit<ProposalsState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<ProposalsSignal, ProposalsState> {
  final UserService _userService;
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  ProposalsCubitCache _cache = const ProposalsCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<List<String>>? _favoritesProposalsIdsSub;
  StreamSubscription<ProposalsCount>? _proposalsCountSub;

  ProposalsCubit(
    this._userService,
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalsState(recentProposalsMaxAge: _recentProposalsMaxAge)) {
    _resetCache();

    _activeAccountIdSub = _userService.watchUser
        .map((event) => event.activeAccount?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);

    _favoritesProposalsIdsSub = _favoritesProposalsIdsSub = _proposalService
        .watchFavoritesProposalsIds()
        .distinct(listEquals)
        .listen(_handleFavoriteProposalsIds);
  }

  void changeFilters({
    Optional<CatalystId>? author,
    Optional<bool>? onlyMy,
    Optional<SignedDocumentRef>? category,
    ProposalsFilterType? type,
    Optional<String>? searchQuery,
    bool? isRecentEnabled,
    bool resetProposals = false,
  }) {
    final filters = _cache.filters.copyWith(
      type: type,
      author: author,
      onlyAuthor: onlyMy,
      category: category,
      searchQuery: searchQuery,
      maxAge: isRecentEnabled != null
          ? Optional(isRecentEnabled ? _recentProposalsMaxAge : null)
          : null,
    );

    if (_cache.filters == filters) {
      return;
    }

    _cache = _cache.copyWith(filters: filters);

    emit(
      state.copyWith(
        isOrderEnabled: _cache.filters.type == ProposalsFilterType.total,
        isRecentProposalsEnabled: _cache.filters.maxAge != null,
      ),
    );

    if (category != null) _rebuildCategories();
    if (type != null) _rebuildOrder();

    _watchProposalsCount(filters: filters.toCountFilters());

    if (resetProposals) {
      emitSignal(const ResetProposalsPaginationSignal());
    }
  }

  void changeOrder(
    ProposalsOrder? order, {
    bool resetProposals = false,
  }) {
    if (_cache.selectedOrder == order) {
      return;
    }

    _cache = _cache.copyWith(selectedOrder: Optional(order));

    _rebuildOrder();

    if (resetProposals) {
      emitSignal(const ResetProposalsPaginationSignal());
    }
  }

  void changeSelectedCategory(SignedDocumentRef? categoryId) {
    emitSignal(ChangeCategorySignal(to: categoryId));
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _favoritesProposalsIdsSub?.cancel();
    _favoritesProposalsIdsSub = null;

    await _proposalsCountSub?.cancel();
    _proposalsCountSub = null;

    return super.close();
  }

  Future<void> getProposals(PageRequest request) async {
    try {
      if (_cache.campaign == null) {
        final campaign = await _campaignService.getActiveCampaign();
        _cache = _cache.copyWith(campaign: Optional(campaign));
      }

      final filters = _cache.filters;
      final order = _resolveEffectiveOrder();

      _logger.finer('Proposals request[$request], filters[$filters], order[$order]');

      final page = await _proposalService.getProposalsPage(
        request: request,
        filters: filters,
        order: order,
      );

      _cache = _cache.copyWith(page: Optional(page));

      _emitCachedProposalsPage();
    } catch (error, stackTrace) {
      _logger.severe('Failed loading page $request', error, stackTrace);
    }
  }

  void init({
    required bool onlyMyProposals,
    required SignedDocumentRef? category,
    required ProposalsFilterType type,
    required ProposalsOrder order,
  }) {
    _resetCache();
    _rebuildOrder();
    unawaited(_loadCampaignCategories());

    changeFilters(onlyMy: Optional(onlyMyProposals), category: Optional(category), type: type);
    changeOrder(order);
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

    if (!isFavorite && _cache.filters.type == ProposalsFilterType.favorites) {
      final page = _cache.page;
      if (page != null) {
        final proposals = List.of(page.items).where((element) => element.selfRef != ref).toList();

        final updatedPage = page.copyWithItems(proposals);

        _cache = _cache.copyWith(page: Optional(updatedPage));

        _emitCachedProposalsPage();
      }
    }

    unawaited(_updateFavoriteProposal(ref, isFavorite: isFavorite));
  }

  void updateSearchQuery(String query) {
    final asOptional = query.isEmpty ? const Optional<String>.empty() : Optional(query);

    if (asOptional.data == _cache.filters.searchQuery) {
      return;
    }

    changeFilters(searchQuery: asOptional, resetProposals: true);

    emit(state.copyWith(hasSearchQuery: !asOptional.isEmpty));
  }

  void _emitCachedProposalsPage() {
    final campaign = _cache.campaign;
    final page = _cache.page;

    if (campaign == null || page == null) {
      return;
    }

    final campaignStage = CampaignStage.fromCampaign(
      campaign,
      DateTimeExt.now(),
    );

    final mappedPage = page.map(
      (proposal) {
        return ProposalViewModel.fromProposalAtStage(
          proposal: proposal,
          campaignName: campaign.name,
          campaignStage: campaignStage,
        );
      },
    );

    final signal = ProposalsPageReadySignal(page: mappedPage);

    emitSignal(signal);
  }

  void _handleActiveAccountIdChange(CatalystId? id) {
    changeFilters(author: Optional(id), resetProposals: true);
  }

  void _handleFavoriteProposalsIds(List<String> ids) {
    emit(state.copyWith(favoritesIds: ids));
  }

  void _handleProposalsCount(ProposalsCount count) {
    _cache = _cache.copyWith(count: count);

    emit(state.copyWith(count: count));
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

  void _rebuildOrder() {
    final filterType = _cache.filters.type;
    final selectedOrder = _resolveEffectiveOrder();

    final options = filterType == ProposalsFilterType.total
        ? const [
            Alphabetical(),
            Budget(isAscending: false),
            Budget(isAscending: true),
          ]
        : const [
            UpdateDate(isAscending: false),
          ];

    final orderItem = options
        .map((order) => ProposalsDropdownOrderItem(order, isSelected: order == selectedOrder))
        .toList();

    emit(state.copyWith(orderItems: orderItem));
  }

  void _resetCache() {
    final activeAccount = _userService.user.activeAccount;
    final filters = ProposalsFilters(author: activeAccount?.catalystId);
    _cache = ProposalsCubitCache(filters: filters);
  }

  ProposalsOrder _resolveEffectiveOrder() {
    final filterType = _cache.filters.type;
    final selectedOrder = _cache.selectedOrder;

    // skip order for non total
    if (filterType != ProposalsFilterType.total) {
      return const UpdateDate(isAscending: false);
    }

    return selectedOrder ?? const Alphabetical();
  }

  Future<void> _updateFavoriteProposal(
    DocumentRef ref, {
    required bool isFavorite,
  }) async {
    try {
      if (isFavorite) {
        await _proposalService.addFavoriteProposal(ref: ref);
      } else {
        await _proposalService.removeFavoriteProposal(ref: ref);
      }
    } catch (error, stack) {
      _logger.severe('Updating proposal[$ref] favorite failed', error, stack);

      emitError(LocalizedException.create(error));
    }
  }

  void _watchProposalsCount({
    required ProposalsCountFilters filters,
  }) {
    unawaited(_proposalsCountSub?.cancel());
    _proposalsCountSub = _proposalService
        .watchProposalsCount(filters: filters)
        .distinct()
        .listen(_handleProposalsCount);
  }
}
