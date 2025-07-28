import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/voting/voting_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('VotingCubit');

/// Manages the voting.
final class VotingCubit extends Cubit<VotingState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<VotingSignal, VotingState> {
  final UserService _userService;
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  VotingCubitCache _cache = const VotingCubitCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<List<String>>? _favoritesProposalsIdsSub;
  StreamSubscription<ProposalsCount>? _proposalsCountSub;

  VotingCubit(
    this._userService,
    this._campaignService,
    this._proposalService,
  ) : super(const VotingState()) {
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
    bool resetProposals = false,
  }) {
    final filters = _cache.filters.copyWith(
      type: type,
      author: author,
      onlyAuthor: onlyMy,
      category: category,
      searchQuery: searchQuery,
    );

    if (_cache.filters == filters) {
      return;
    }

    _cache = _cache.copyWith(filters: filters);

    _dispatchState();
    _watchProposalsCount(filters: filters.toCountFilters());

    if (resetProposals) {
      emitSignal(const ResetPaginationVotingSignal());
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
    _dispatchState();

    if (resetProposals) {
      emitSignal(const ResetPaginationVotingSignal());
    }
  }

  void changeSelectedCategory(SignedDocumentRef? categoryId) {
    emitSignal(ChangeCategoryVotingSignal(to: categoryId));
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
      final selectedOrder = _cache.selectedOrder;
      final effectiveOrder = _resolveEffectiveOrder(filters.type, selectedOrder);

      _logger.finer('Proposals request[$request], filters[$filters], order[$effectiveOrder]');

      final page = await _proposalService.getProposalsPage(
        request: request,
        filters: filters,
        order: effectiveOrder,
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
    unawaited(_loadCampaign());
    unawaited(_loadVotingPower());

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

    _cache = _cache.copyWith(favoriteIds: Optional(favoritesIds));
    _dispatchState();

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
  }

  List<ProposalsCategorySelectorItem> _buildCategorySelectorItems(
    List<CampaignCategory> categories,
    SignedDocumentRef? selectedCategory,
  ) {
    return categories.map((e) {
      return ProposalsCategorySelectorItem(
        ref: e.selfRef,
        name: e.categoryText,
        isSelected: e.selfRef.id == selectedCategory?.id,
      );
    }).toList();
  }

  List<ProposalsDropdownOrderItem> _buildOrderItems(
    ProposalsFilterType filterType,
    ProposalsOrder? selectedOrder,
  ) {
    final effectiveOrder = _resolveEffectiveOrder(filterType, selectedOrder);

    final options = filterType == ProposalsFilterType.total
        ? const [
            Alphabetical(),
            Budget(isAscending: false),
            Budget(isAscending: true),
          ]
        : const [
            UpdateDate(isAscending: false),
          ];

    return options
        .map((order) => ProposalsDropdownOrderItem(order, isSelected: order == effectiveOrder))
        .toList();
  }

  VotingPhaseProgressViewModel? _buildVotingPhase(Campaign? campaign) {
    final campaignVotingPhase = campaign?.phaseStateTo(CampaignPhaseType.communityVoting);
    final campaignStartDate = campaign?.startDate;

    if (campaignVotingPhase != null && campaignStartDate != null) {
      return VotingPhaseProgressViewModel.fromModel(
        state: campaignVotingPhase,
        campaignStartDate: campaignStartDate,
      );
    } else {
      return null;
    }
  }

  void _dispatchState() {
    final newState = _rebuildState();
    if (state != newState) {
      emit(newState);
    }
  }

  void _emitCachedProposalsPage() {
    final campaign = _cache.campaign;
    final page = _cache.page;

    if (campaign == null || page == null) {
      return;
    }

    final mappedPage = page.map(ProposalBrief.fromProposal);
    final signal = PageReadyVotingSignal(page: mappedPage);

    emitSignal(signal);
  }

  void _handleActiveAccountIdChange(CatalystId? id) {
    changeFilters(author: Optional(id), resetProposals: true);
  }

  void _handleFavoriteProposalsIds(List<String> ids) {
    _cache = _cache.copyWith(favoriteIds: Optional(ids));
    _dispatchState();
  }

  void _handleProposalsCount(ProposalsCount count) {
    _cache = _cache.copyWith(count: count);
    _dispatchState();
  }

  Future<void> _loadCampaign() async {
    final campaign = await _campaignService.getActiveCampaign();
    _cache = _cache.copyWith(campaign: Optional(campaign));

    if (!isClosed) {
      _dispatchState();
    }
  }

  Future<void> _loadVotingPower() async {
    // TODO(dt-iohk): fetch voting power from service
    final votingPower = VotingPower(
      amount: 1520,
      status: VotingPowerStatus.confirmed,
      updatedAt: DateTime(2025, 5, 1, 13, 45),
    );

    _cache = _cache.copyWith(votingPower: Optional(votingPower));

    if (!isClosed) {
      _dispatchState();
    }
  }

  VotingState _rebuildState() {
    final campaign = _cache.campaign;
    final favoriteIds = _cache.favoriteIds ?? const [];
    final votingPower = _cache.votingPower;
    final categories = campaign?.categories ?? const [];
    final selectedCategoryRef = _cache.filters.category;
    final filters = _cache.filters;
    final count = _cache.count;

    final selectedCategory =
        campaign?.categories.firstWhereOrNull((e) => e.selfRef == selectedCategoryRef);
    final fundNumber = campaign?.fundNumber;
    final votingPowerViewModel = votingPower != null
        ? VotingPowerViewModel.fromModel(votingPower)
        : const VotingPowerViewModel();
    final votingPhaseViewModel = _buildVotingPhase(campaign);
    final hasSearchQuery = filters.searchQuery == null;
    final categorySelectorItems = _buildCategorySelectorItems(categories, selectedCategoryRef);
    final orderItems = _buildOrderItems(_cache.filters.type, _cache.selectedOrder);
    final isOrderEnabled = _cache.filters.type == ProposalsFilterType.total;

    return state.copyWith(
      selectedCategory: Optional(selectedCategory),
      fundNumber: Optional(fundNumber),
      votingPower: votingPowerViewModel,
      votingPhase: votingPhaseViewModel,
      hasSearchQuery: hasSearchQuery,
      favoritesIds: favoriteIds,
      count: count,
      categorySelectorItems: categorySelectorItems,
      orderItems: orderItems,
      isOrderEnabled: isOrderEnabled,
    );
  }

  void _resetCache() {
    final activeAccount = _userService.user.activeAccount;
    final filters = ProposalsFilters(author: activeAccount?.catalystId);
    _cache = VotingCubitCache(filters: filters);
  }

  ProposalsOrder _resolveEffectiveOrder(
    ProposalsFilterType filterType,
    ProposalsOrder? selectedOrder,
  ) {
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
