import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/voting/voting_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('VotingCubit');

/// Manages the voting.
final class VotingCubit extends Cubit<VotingState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<VotingSignal, VotingState> {
  final UserService _userService;
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  VotingCubitCache _cache = const VotingCubitCache();
  late Timer _countdownTimer;

  StreamSubscription<Account?>? _activeAccountSub;
  StreamSubscription<Map<VotingPageTab, int>>? _proposalsCountSub;
  StreamSubscription<Page<ProposalBrief>>? _proposalsPageSub;

  Completer<void>? _proposalsRequestCompleter;

  VotingCubit(
    this._userService,
    this._campaignService,
    this._proposalService,
  ) : super(const VotingState()) {
    _resetCache();
    _rebuildProposalsCountSubs();

    _activeAccountSub = _userService.watchUser
        .map((event) => event.activeAccount)
        .distinct()
        .listen(_handleActiveAccountChange);

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _dispatchState(),
    );
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
    Optional<VotingPageTab>? tab,
    Optional<String>? searchQuery,
    bool resetProposals = false,
  }) {
    _cache = _cache.copyWith(tab: tab);

    final filters = _cache.filters.copyWith(
      status: const Optional(ProposalStatusFilter.aFinal),
      isFavorite: _cache.tab == VotingPageTab.favorites
          ? const Optional(true)
          : const Optional.empty(),
      originalAuthor: Optional(_cache.tab == VotingPageTab.my ? _cache.activeAccountId : null),
      categoryId: categoryId,
      searchQuery: searchQuery,
      latestUpdate: const Optional.empty(),
      campaign: Optional(ProposalsCampaignFilters.active()),
      voteBy: _cache.tab == VotingPageTab.votedOn
          ? Optional(_cache.activeAccountId)
          : const Optional.empty(),
    );

    if (_cache.filters == filters) {
      return;
    }

    final categoryChanged = _cache.filters.categoryId != filters.categoryId;
    final searchQueryChanged = _cache.filters.searchQuery != filters.searchQuery;
    final campaignChanged = _cache.filters.campaign != filters.campaign;

    final shouldRebuildCountSubs = categoryChanged || searchQueryChanged || campaignChanged;

    _cache = _cache.copyWith(filters: filters);

    if (shouldRebuildCountSubs) _rebuildProposalsCountSubs();
    if (resetProposals) emitSignal(const ResetPaginationVotingSignal());
  }

  void changeSelectedCategory(String? categoryId) {
    emitSignal(ChangeCategoryVotingSignal(to: categoryId));
  }

  @override
  Future<void> close() async {
    await _activeAccountSub?.cancel();
    _activeAccountSub = null;

    await _proposalsCountSub?.cancel();
    _proposalsCountSub = null;

    await _proposalsPageSub?.cancel();
    _proposalsPageSub = null;

    _countdownTimer.cancel();

    if (_proposalsRequestCompleter != null && !_proposalsRequestCompleter!.isCompleted) {
      _proposalsRequestCompleter!.complete();
    }
    _proposalsRequestCompleter = null;

    return super.close();
  }

  Future<void> getProposals(PageRequest request) async {
    final filters = _cache.filters;
    const order = Alphabetical();

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
    required String? categoryId,
    required VotingPageTab? tab,
  }) {
    _resetCache();

    unawaited(_loadVotingPower());
    unawaited(_loadCampaign());

    changeFilters(categoryId: Optional(categoryId), tab: Optional(tab));
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

  List<ProposalsCategorySelectorItem> _buildCategorySelectorItems(
    List<CampaignCategory> categories,
    String? selectedCategoryId,
  ) {
    return categories.map((e) {
      return ProposalsCategorySelectorItem(
        ref: e.id,
        name: e.formattedCategoryName,
        isSelected: e.id.id == selectedCategoryId,
      );
    }).toList();
  }

  ProposalsFiltersV2 _buildProposalsCountFilters(VotingPageTab tab) {
    return switch (tab) {
      VotingPageTab.total => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional.empty(),
        originalAuthor: const Optional.empty(),
      ),
      VotingPageTab.favorites => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional(true),
        originalAuthor: const Optional.empty(),
      ),
      VotingPageTab.my => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional.empty(),
        originalAuthor: Optional(_cache.activeAccountId),
      ),
      VotingPageTab.votedOn => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional.empty(),
        originalAuthor: const Optional.empty(),
        voteBy: Optional(_cache.activeAccountId),
      ),
    };
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

  VotingPhaseProgressDetailsViewModel? _buildVotingPhaseDetails(Campaign? campaign) {
    final votingPhase = _buildVotingPhase(campaign);
    final now = DateTimeExt.now();
    return votingPhase?.progress(now);
  }

  void _dispatchState() {
    final newState = _rebuildState();
    if (state != newState) {
      emit(newState);
    }
  }

  void _handleActiveAccountChange(Account? account) {
    if (account?.catalystId != _cache.activeAccountId) {
      _cache = _cache.copyWith(activeAccountId: Optional(account?.catalystId));
      changeFilters(resetProposals: true);
    }

    if (_cache.votingPower != account?.votingPower) {
      _cache = _cache.copyWith(votingPower: Optional(account?.votingPower));
      _dispatchState();
    }
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

    emitSignal(PageReadyVotingSignal(page: page));
  }

  void _handleProposalsCountChange(Map<VotingPageTab, int> data) {
    _logger.finest('Proposals count changed: $data');

    emit(state.copyWith(count: Map.unmodifiable(data)));
  }

  Future<void> _loadCampaign() => _campaign;

  Future<void> _loadVotingPower() async {
    await _userService.refreshActiveAccountVotingPower();
  }

  void _rebuildProposalsCountSubs() {
    final streams = VotingPageTab.values.map((tab) {
      final filters = _buildProposalsCountFilters(tab);
      return _proposalService
          .watchProposalsCountV2(filters: filters)
          .distinct()
          .map((count) => MapEntry(tab, count));
    });

    unawaited(_proposalsCountSub?.cancel());
    _proposalsCountSub = Rx.combineLatest(
      streams,
      Map<VotingPageTab, int>.fromEntries,
    ).startWith({}).listen(_handleProposalsCountChange);
  }

  VotingState _rebuildState() {
    final campaign = _cache.campaign;
    final votingPower = _cache.votingPower;
    final categories = campaign?.categories ?? const [];
    final selectedCategoryId = _cache.filters.categoryId;
    final filters = _cache.filters;

    final selectedCategory = campaign?.categories.firstWhereOrNull(
      (e) => e.id.id == selectedCategoryId,
    );

    final fundNumber = campaign?.fundNumber;
    final votingPowerViewModel = votingPower != null
        ? VotingPowerViewModel.fromModel(votingPower)
        : const VotingPowerViewModel();
    final votingPhaseViewModel = _buildVotingPhaseDetails(campaign);
    final hasSearchQuery = filters.searchQuery != null;
    final categorySelectorItems = _buildCategorySelectorItems(categories, selectedCategoryId);

    final header = VotingHeaderData(
      showCategoryPicker: votingPhaseViewModel?.status.isActive ?? false,
      category: selectedCategory != null
          ? VotingHeaderCategoryData.fromModel(selectedCategory)
          : null,
    );

    return state.copyWith(
      header: header,
      fundNumber: Optional(fundNumber),
      votingPower: votingPowerViewModel,
      votingPhase: Optional(votingPhaseViewModel),
      hasSearchQuery: hasSearchQuery,
      categorySelectorItems: categorySelectorItems,
    );
  }

  void _resetCache() {
    final activeAccount = _userService.user.activeAccount;
    final filters = ProposalsFiltersV2(campaign: ProposalsCampaignFilters.active());

    _cache = VotingCubitCache(
      filters: filters,
      votingPower: activeAccount?.votingPower,
      activeAccountId: activeAccount?.catalystId,
    );
  }

  void _updateFavoriteProposalLocally(DocumentRef ref, bool isFavorite) {
    final count = Map.of(state.count)
      ..update(
        VotingPageTab.favorites,
        (value) => value + (isFavorite ? 1 : -1),
        ifAbsent: () => (isFavorite ? 1 : 0),
      );

    emit(state.copyWith(count: Map.unmodifiable(count)));

    final page = _cache.page;
    if (page != null) {
      var items = List.of(page.items);
      if (_cache.tab != VotingPageTab.favorites || isFavorite) {
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
