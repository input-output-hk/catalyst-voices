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
  final VotingService _votingService;

  VotingCubitCache _cache = const VotingCubitCache();
  Timer? _countdownTimer;

  StreamSubscription<Account?>? _activeAccountSub;
  StreamSubscription<Campaign?>? _activeCampaignSub;
  StreamSubscription<AccountVotingRole?>? _activeVotingRoleSub;
  StreamSubscription<Map<VotingPageTab, int>>? _proposalsCountSub;
  StreamSubscription<Page<ProposalBrief>>? _proposalsPageSub;

  Completer<void>? _proposalsRequestCompleter;

  VotingCubit(
    this._userService,
    this._campaignService,
    this._proposalService,
    this._votingService,
  ) : super(const VotingState());

  void changeFilters({
    Optional<String>? categoryId,
    Optional<VotingPageTab>? tab,
    Optional<String>? searchQuery,
    Optional<VoteType>? voteType,
    bool resetProposals = false,
  }) {
    _cache = _cache.copyWith(
      tab: tab,
      voteType: voteType,
    );

    final campaign = _cache.campaign;
    final activeAccountId = _cache.activeAccountId;

    final filters = _cache.filters.copyWith(
      status: const Optional(ProposalStatusFilter.aFinal),
      isFavorite: _cache.tab == VotingPageTab.favorites
          ? const Optional(true)
          : const Optional.empty(),
      relationships: {
        if (_cache.tab == VotingPageTab.myFinalProposals && activeAccountId != null)
          OriginalAuthor(activeAccountId),
      },
      categoryId: categoryId,
      searchQuery: searchQuery,
      latestUpdate: const Optional.empty(),
      campaign: Optional(
        campaign != null
            ? CampaignFilters.from(campaign)
            : const CampaignFilters(categoriesIds: {}),
      ),
      voteBy: _cache.tab == VotingPageTab.myVotes
          ? Optional(_cache.activeAccountId)
          : const Optional.empty(),
      voteType: _cache.tab == VotingPageTab.myVotes
          ? Optional(_cache.voteType)
          : const Optional.empty(),
    );

    if (_cache.filters == filters) {
      return;
    }

    final categoryChanged = _cache.filters.categoryId != filters.categoryId;
    final searchQueryChanged = _cache.filters.searchQuery != filters.searchQuery;
    final campaignChanged = _cache.filters.campaign != filters.campaign;
    final voteTypeChanged = _cache.filters.voteType != filters.voteType;

    final shouldRebuildCountSubs =
        categoryChanged || searchQueryChanged || campaignChanged || voteTypeChanged;

    _cache = _cache.copyWith(filters: filters);

    if (shouldRebuildCountSubs) _rebuildProposalsCountSubs();
    if (resetProposals) emitSignal(const ResetPaginationVotingSignal());
  }

  void changeSelectedCategory(String? categoryId) {
    emitSignal(ChangeCategoryVotingSignal(to: categoryId));
  }

  void changeVoteTypeFilter(VoteType? voteType) {
    emitSignal(ChangeVoteTypeFilterVotingSignal(voteType));
  }

  @override
  Future<void> close() async {
    await _activeAccountSub?.cancel();
    _activeAccountSub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    await _activeVotingRoleSub?.cancel();
    _activeVotingRoleSub = null;

    await _proposalsCountSub?.cancel();
    _proposalsCountSub = null;

    await _proposalsPageSub?.cancel();
    _proposalsPageSub = null;

    _countdownTimer?.cancel();
    _countdownTimer = null;

    if (_proposalsRequestCompleter != null && !_proposalsRequestCompleter!.isCompleted) {
      _proposalsRequestCompleter!.complete();
    }
    _proposalsRequestCompleter = null;

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

  Future<void> init({
    required String? categoryId,
    required VotingPageTab? tab,
    required VoteType? voteType,
  }) async {
    _resetCache();
    _rebuildProposalsCountSubs();
    await _loadCampaign();

    if (isClosed) {
      return;
    }

    changeFilters(
      categoryId: Optional(categoryId),
      tab: Optional(tab),
      voteType: Optional(voteType),
    );

    unawaited(_activeAccountSub?.cancel());
    _activeAccountSub = _userService.watchUser
        .map((event) => event.activeAccount)
        .distinct()
        .listen(_handleActiveAccountChange);

    unawaited(_activeCampaignSub?.cancel());
    _activeCampaignSub = _campaignService.watchActiveCampaign.distinct().listen(
      _handleActiveCampaignChange,
    );

    unawaited(_activeVotingRoleSub?.cancel());
    _activeVotingRoleSub = _votingService.watchActiveVotingRole().distinct().listen(
      _handleActiveVotingRoleChange,
    );

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _dispatchState(),
    );
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
        await _proposalService.removeFavoriteProposal(id: ref);
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

  ProposalsFiltersV2? _buildProposalsCountFilters(VotingPageTab tab) {
    return switch (tab) {
      // Results tab does not display the counter.
      VotingPageTab.results => null,
      VotingPageTab.total => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional.empty(),
        relationships: const {},
      ),
      VotingPageTab.favorites => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional(true),
        relationships: const {},
      ),
      VotingPageTab.myFinalProposals => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional.empty(),
        relationships: {
          if (_cache.activeAccountId != null) OriginalAuthor(_cache.activeAccountId!),
        },
      ),
      VotingPageTab.myVotes => _cache.filters.copyWith(
        status: const Optional(ProposalStatusFilter.aFinal),
        isFavorite: const Optional.empty(),
        relationships: const {},
        voteBy: Optional(_cache.activeAccountId),
        voteType: Optional(_cache.voteType),
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
    final activeAccountId = account?.catalystId;
    if (activeAccountId != _cache.activeAccountId) {
      _cache = _cache.copyWith(activeAccountId: Optional(activeAccountId));
      changeFilters(resetProposals: true);
    }
  }

  void _handleActiveCampaignChange(Campaign? campaign) {
    if (_cache.campaign?.id == campaign?.id) {
      return;
    }

    _logger.finest('Active campaign changed: ${campaign?.id}');

    _cache = _cache.copyWith(campaign: Optional(campaign));

    if (_cache.filters.categoryId != null) {
      changeSelectedCategory(null);
    } else {
      changeFilters(
        categoryId: const Optional.empty(),
        resetProposals: true,
      );
      _dispatchState();
    }
  }

  void _handleActiveVotingRoleChange(AccountVotingRole? votingRole) {
    if (_cache.votingRole != votingRole) {
      _cache = _cache.copyWith(votingRole: Optional(votingRole));
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

  Future<void> _loadCampaign() async {
    final campaign = await _campaignService.getActiveCampaign();
    if (!isClosed) {
      _handleActiveCampaignChange(campaign);
    }
  }

  void _rebuildProposalsCountSubs() {
    final streams = VotingPageTab.values.map((tab) {
      final filters = _buildProposalsCountFilters(tab);
      final stream = filters != null
          ? _proposalService.watchProposalsCountV2(filters: filters)
          : Stream.value(0);

      return stream.distinct().map((count) => MapEntry(tab, count));
    });

    unawaited(_proposalsCountSub?.cancel());
    _proposalsCountSub = Rx.combineLatest(
      streams,
      Map<VotingPageTab, int>.fromEntries,
    ).startWith(state.count).listen(_handleProposalsCountChange);
  }

  VotingState _rebuildState() {
    final campaign = _cache.campaign;
    final votingRole = _cache.votingRole;
    final categories = campaign?.categories ?? const [];
    final selectedCategoryId = _cache.filters.categoryId;
    final filters = _cache.filters;

    final selectedCategory = campaign?.categories.firstWhereOrNull(
      (e) => e.id.id == selectedCategoryId,
    );

    final fundNumber = campaign?.fundNumber;
    final votingRoleViewModel = votingRole != null
        ? VotingRoleViewModel.fromModel(votingRole)
        : const EmptyVotingRoleViewModel();
    final votingPhaseViewModel = _buildVotingPhaseDetails(campaign);
    final hasSearchQuery = filters.searchQuery != null;
    final categorySelectorItems = _buildCategorySelectorItems(categories, selectedCategoryId);

    final header = VotingHeaderData(
      showCategoryPicker: votingPhaseViewModel?.status.isActive ?? false,
      category: selectedCategory != null
          ? VotingHeaderCategoryData.fromModel(selectedCategory)
          : null,
    );

    final isDelegator = votingRole is AccountVotingRoleDelegator;
    final isVotingResultsOrTallyActive = campaign?.isVotingResultsOrTallyActive();

    return state.copyWith(
      header: header,
      fundNumber: Optional(fundNumber),
      votingRole: votingRoleViewModel,
      votingPhase: Optional(votingPhaseViewModel),
      hasSearchQuery: hasSearchQuery,
      isDelegator: isDelegator,
      isVotingResultsOrTallyActive: isVotingResultsOrTallyActive,
      categorySelectorItems: categorySelectorItems,
    );
  }

  void _resetCache() {
    final activeAccount = _userService.user.activeAccount;
    final filters = ProposalsFiltersV2(campaign: CampaignFilters.active());

    _cache = VotingCubitCache(
      filters: filters,
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

extension CampaignExt on Campaign {
  bool isVotingResultsOrTallyActive() {
    final results = phaseStateTo(CampaignPhaseType.votingResults);
    final tally = phaseStateTo(CampaignPhaseType.votingTally);

    return results.status.isActive || tally.status.isActive;
  }
}
