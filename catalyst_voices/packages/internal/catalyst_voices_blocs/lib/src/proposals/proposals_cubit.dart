import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/proposals/proposals_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:rxdart/rxdart.dart';

const _recentProposalsMaxAge = Duration(hours: 72);
final _logger = Logger('ProposalsCubit');

/// Manages the proposals.
///
/// This cubit has [ProposalsCubitCache] to store the data which allows to reduce
/// the number of calls to the services.
///
/// Allows to get paginated proposals based on the filters and order.
final class ProposalsCubit extends Cubit<ProposalsState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<ProposalsSignal, ProposalsState> {
  final UserService _userService;
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  ProposalsCubitCache _cache = ProposalsCubitCache(
    filters: ProposalsFiltersV2(campaign: ProposalsCampaignFilters.active()),
  );

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<Map<ProposalsPageTab, int>>? _proposalsCountSub;
  StreamSubscription<Page<ProposalBrief>>? _proposalsPageSub;

  Completer<void>? _proposalsRequestCompleter;

  ProposalsCubit(
    this._userService,
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalsState(recentProposalsMaxAge: _recentProposalsMaxAge)) {
    _resetCache();
    _rebuildProposalsCountSubs();

    _activeAccountIdSub = _userService.watchUser
        .map((event) => event.activeAccount?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);
  }

  Future<Campaign?> get _campaign async {
    final cachedCampaign = _cache.campaign;
    if (cachedCampaign != null) {
      return cachedCampaign;
    }

    final campaign = await _campaignService.getActiveCampaign();
    _cache = _cache.copyWith(campaign: Optional(campaign));
    return campaign;
  }

  void changeFilters({
    Optional<String>? categoryId,
    Optional<ProposalsPageTab>? tab,
    Optional<String>? searchQuery,
    bool? isRecentEnabled,
    bool resetProposals = false,
  }) {
    _cache = _cache.copyWith(tab: tab);
    emit(state.copyWith(isOrderEnabled: _cache.tab == ProposalsPageTab.total));

    final status = switch (_cache.tab) {
      ProposalsPageTab.drafts => ProposalStatusFilter.draft,
      ProposalsPageTab.finals => ProposalStatusFilter.aFinal,
      ProposalsPageTab.total || ProposalsPageTab.favorites || ProposalsPageTab.my || null => null,
    };

    final filters = _cache.filters.copyWith(
      status: Optional(status),
      isFavorite: _cache.tab == ProposalsPageTab.favorites
          ? const Optional(true)
          : const Optional.empty(),
      originalAuthor: Optional(_cache.tab == ProposalsPageTab.my ? _cache.activeAccountId : null),
      categoryId: categoryId,
      searchQuery: searchQuery,
      latestUpdate: isRecentEnabled != null
          ? Optional(isRecentEnabled ? _recentProposalsMaxAge : null)
          : null,
      campaign: Optional(ProposalsCampaignFilters.active()),
    );

    if (_cache.filters == filters) {
      return;
    }

    final statusChanged = _cache.filters.status != filters.status;
    final categoryChanged = _cache.filters.categoryId != filters.categoryId;
    final searchQueryChanged = _cache.filters.searchQuery != filters.searchQuery;
    final latestUpdateChanged = _cache.filters.latestUpdate != filters.latestUpdate;
    final campaignChanged = _cache.filters.campaign != filters.campaign;

    final shouldRebuildCountSubs =
        categoryChanged || searchQueryChanged || latestUpdateChanged || campaignChanged;

    _cache = _cache.copyWith(filters: filters);

    emit(
      state.copyWith(
        isRecentProposalsEnabled: _cache.filters.latestUpdate != null,
      ),
    );

    if (categoryId != null) _rebuildCategories();
    if (statusChanged) _rebuildOrder();
    if (shouldRebuildCountSubs) _rebuildProposalsCountSubs();
    if (resetProposals) emitSignal(const ResetPaginationProposalsSignal());
  }

  void changeOrder(
    ProposalsOrder? order, {
    bool resetProposals = false,
  }) {
    if (_cache.order == order) {
      return;
    }

    _cache = _cache.copyWith(order: Optional(order));

    _rebuildOrder();

    if (resetProposals) {
      emitSignal(const ResetPaginationProposalsSignal());
    }
  }

  void changeSelectedCategory(SignedDocumentRef? categoryRef) {
    emitSignal(ChangeCategoryProposalsSignal(to: categoryRef));
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _proposalsCountSub?.cancel();
    _proposalsCountSub = null;

    await _proposalsPageSub?.cancel();
    _proposalsPageSub = null;

    if (_proposalsRequestCompleter != null && !_proposalsRequestCompleter!.isCompleted) {
      _proposalsRequestCompleter!.complete();
    }
    _proposalsRequestCompleter = null;

    return super.close();
  }

  Future<void> getProposals(PageRequest request) async {
    final filters = _cache.filters;
    final order = _resolveEffectiveOrder();

    if (_proposalsRequestCompleter != null && !_proposalsRequestCompleter!.isCompleted) {
      _proposalsRequestCompleter!.complete();
    }
    _proposalsRequestCompleter = Completer();

    await _proposalsPageSub?.cancel();
    _proposalsPageSub = _proposalService
        .watchProposalsBriefPageV2(request: request, order: order, filters: filters)
        .map((page) => page.map(ProposalBrief.fromData))
        .distinct()
        .listen(_handleProposalsChange);

    await _proposalsRequestCompleter?.future;
  }

  void init({
    String? categoryId,
    ProposalsPageTab? tab,
    ProposalsOrder order = const Alphabetical(),
  }) {
    _resetCache();
    _rebuildOrder();
    unawaited(_loadCampaignCategories());

    changeFilters(categoryId: Optional(categoryId), tab: Optional(tab));
    changeOrder(order);
  }

  /// Changes the favorite status of the proposal with [ref].
  Future<void> onChangeFavoriteProposal(
    DocumentRef ref, {
    required bool isFavorite,
  }) async {
    _updateFavoriteProposalLocally(ref, isFavorite);

    try {
      if (isFavorite) {
        await _proposalService.addFavoriteProposal(id: ref);
      } else {
        await _proposalService.removeFavoriteProposal(ref: ref);
      }
    } catch (error, stack) {
      _logger.severe('Updating proposal[$ref] favorite failed', error, stack);

      emitError(LocalizedException.create(error));
    }
  }

  void updateSearchQuery(String query) {
    final asOptional = query.isEmpty ? const Optional<String>.empty() : Optional(query);

    if (asOptional.data == _cache.filters.searchQuery) {
      return;
    }

    changeFilters(searchQuery: asOptional, resetProposals: true);

    emit(state.copyWith(hasSearchQuery: !asOptional.isEmpty));
  }

  ProposalsFiltersV2 _buildProposalsCountFilters(ProposalsPageTab tab) {
    return switch (tab) {
      ProposalsPageTab.total => _cache.filters.copyWith(
        status: const Optional.empty(),
        isFavorite: const Optional.empty(),
        originalAuthor: const Optional.empty(),
      ),
      ProposalsPageTab.drafts => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.draft),
        isFavorite: const Optional.empty(),
        originalAuthor: const Optional.empty(),
      ),
      ProposalsPageTab.finals => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional.empty(),
        originalAuthor: const Optional.empty(),
      ),
      ProposalsPageTab.favorites => _cache.filters.copyWith(
        status: const Optional.empty(),
        isFavorite: const Optional(true),
        originalAuthor: const Optional.empty(),
      ),
      ProposalsPageTab.my => _cache.filters.copyWith(
        status: const Optional.empty(),
        isFavorite: const Optional.empty(),
        originalAuthor: Optional(_cache.activeAccountId),
      ),
    };
  }

  void _handleActiveAccountIdChange(CatalystId? id) {
    _cache = _cache.copyWith(activeAccountId: Optional(id));
    final isMyTab = _cache.tab == ProposalsPageTab.my;

    changeFilters(resetProposals: isMyTab);
  }

  void _handleProposalsChange(Page<ProposalBrief> page) {
    _logger.finest(
      'Got page[${page.page}] with proposals[${page.items.length}]. '
      'Total[${page.total}]',
    );

    final requestCompleter = _proposalsRequestCompleter;
    if (requestCompleter != null && !requestCompleter.isCompleted) {
      requestCompleter.complete();
    }

    _cache = _cache.copyWith(page: Optional(page));

    emitSignal(PageReadyProposalsSignal(page: page));
  }

  void _handleProposalsCountChange(Map<ProposalsPageTab, int> data) {
    _logger.finest('Proposals count changed: $data');

    emit(state.copyWith(count: Map.unmodifiable(data)));
  }

  Future<void> _loadCampaignCategories() async {
    final campaign = await _campaign;

    _cache = _cache.copyWith(categories: Optional(campaign?.categories));

    if (!isClosed) {
      _rebuildCategories();
    }
  }

  void _rebuildCategories() {
    final selectedCategory = _cache.filters.categoryId;
    final categories = _cache.categories ?? const [];

    final items = categories.map((e) {
      return ProposalsCategorySelectorItem(
        ref: e.id,
        name: e.formattedCategoryName,
        isSelected: e.id.id == selectedCategory,
      );
    }).toList();

    final category = ProposalsCategoryState(items);

    emit(state.copyWith(category: category));
  }

  void _rebuildOrder() {
    final isNoStatusFilter = _cache.filters.status == null;
    final selectedOrder = _resolveEffectiveOrder();

    final options = isNoStatusFilter
        ? const [
            Alphabetical(),
            Budget(isAscending: false),
            Budget(isAscending: true),
          ]
        : const [
            UpdateDate(isAscending: false),
          ];

    final items = options
        .map((order) => ProposalsDropdownOrderItem(order, isSelected: order == selectedOrder))
        .toList();

    final order = ProposalsOrderState(items);

    emit(state.copyWith(order: order));
  }

  void _rebuildProposalsCountSubs() {
    final streams = ProposalsPageTab.values.map((tab) {
      final filters = _buildProposalsCountFilters(tab);
      return _proposalService
          .watchProposalsCountV2(filters: filters)
          .distinct()
          .map((count) => MapEntry(tab, count));
    });

    unawaited(_proposalsCountSub?.cancel());
    _proposalsCountSub = Rx.combineLatest(
      streams,
      Map<ProposalsPageTab, int>.fromEntries,
    ).startWith({}).listen(_handleProposalsCountChange);
  }

  void _resetCache() {
    final activeAccountId = _userService.user.activeAccount?.catalystId;
    final filters = ProposalsFiltersV2(campaign: ProposalsCampaignFilters.active());

    _cache = ProposalsCubitCache(
      filters: filters,
      activeAccountId: activeAccountId,
    );
  }

  ProposalsOrder _resolveEffectiveOrder() {
    final isTotalTab = _cache.tab == ProposalsPageTab.total;
    final selectedOrder = _cache.order;

    // skip order for non total
    if (!isTotalTab) {
      return const UpdateDate(isAscending: false);
    }

    return selectedOrder ?? const Alphabetical();
  }

  void _updateFavoriteProposalLocally(DocumentRef ref, bool isFavorite) {
    final count = Map.of(state.count)
      ..update(
        ProposalsPageTab.favorites,
        (value) => value + (isFavorite ? 1 : -1),
        ifAbsent: () => (isFavorite ? 1 : 0),
      );

    emit(state.copyWith(count: Map.unmodifiable(count)));

    final page = _cache.page;
    if (page != null) {
      var items = List.of(page.items);
      if (_cache.tab != ProposalsPageTab.favorites || isFavorite) {
        items = items.map((e) => e.id == ref ? e.copyWith(isFavorite: isFavorite) : e).toList();
      } else {
        items = items.where((element) => element.id != ref).toList();
      }

      final diff = page.items.length - items.length;

      final updatedPage = page.copyWith(
        items: items,
        total: page.total - diff,
      );

      _handleProposalsChange(updatedPage);
    }
  }
}
