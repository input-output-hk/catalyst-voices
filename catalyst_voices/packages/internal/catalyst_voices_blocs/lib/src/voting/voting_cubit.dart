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
  final VotingBallotBuilder _ballotBuilder;
  final VotingService _votingService;

  VotingCubitCache _cache = const VotingCubitCache();
  late Timer _countdownTimer;

  StreamSubscription<Account?>? _activeAccountSub;
  StreamSubscription<List<String>>? _favoritesProposalsIdsSub;
  StreamSubscription<ProposalsCount>? _proposalsCountSub;
  StreamSubscription<List<Vote>>? _watchedCastedVotesSub;

  VotingCubit(
    this._userService,
    this._campaignService,
    this._proposalService,
    this._ballotBuilder,
    this._votingService,
  ) : super(const VotingState()) {
    _resetCache();

    _activeAccountSub = _userService.watchUser
        .map((event) => event.activeAccount)
        .distinct()
        .listen(_handleActiveAccountChange);

    _favoritesProposalsIdsSub = _proposalService
        .watchFavoritesProposalsIds()
        .distinct(listEquals)
        .listen(_handleFavoriteProposalsIds);

    _watchedCastedVotesSub = _votingService
        .watchedCastedVotes()
        .distinct(listEquals)
        .listen(_handleLastCastedChange);

    _ballotBuilder.addListener(_handleBallotBuilderChange);

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _dispatchState(),
    );
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

  void changeSelectedCategory(SignedDocumentRef? categoryRef) {
    emitSignal(ChangeCategoryVotingSignal(to: categoryRef));
  }

  @override
  Future<void> close() async {
    await _activeAccountSub?.cancel();
    _activeAccountSub = null;

    await _favoritesProposalsIdsSub?.cancel();
    _favoritesProposalsIdsSub = null;

    await _proposalsCountSub?.cancel();
    _proposalsCountSub = null;

    await _watchedCastedVotesSub?.cancel();
    _watchedCastedVotesSub = null;

    _ballotBuilder.removeListener(_handleBallotBuilderChange);
    _countdownTimer.cancel();

    return super.close();
  }

  Future<void> getProposals(PageRequest request) async {
    try {
      if (_cache.campaign == null) {
        final campaign = await _campaignService.getActiveCampaign();
        _cache = _cache.copyWith(campaign: Optional(campaign));
      }

      final filters = _cache.filters;

      _logger.finer('Proposals request[$request], filters[$filters]');

      final page = await _proposalService.getProposalsPage(
        request: request,
        filters: filters,
        order: const Alphabetical(),
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
  }) {
    _resetCache();
    unawaited(_loadCampaign());
    unawaited(_loadVotingPower());
    unawaited(_loadFavoriteProposals());
    unawaited(_loadLastCastedVotes());

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

    _cache = _cache.copyWith(favoriteIds: Optional(favoritesIds));
    _dispatchState();

    if (!isFavorite && _cache.filters.type.isFavorite) {
      final page = _cache.page;
      if (page != null) {
        final proposals = page.items.where((element) => element.proposal.selfRef != ref).toList();
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
        name: e.formattedCategoryName,
        isSelected: e.selfRef.id == selectedCategory?.id,
      );
    }).toList();
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

  void _emitCachedProposalsPage() {
    final campaign = _cache.campaign;
    final page = _cache.page;
    final favoriteIds = _cache.favoriteIds ?? [];
    final lastCastedVote = _cache.lastCastedVote ?? [];
    final showComments =
        campaign != null &&
        !campaign.phaseStateTo(CampaignPhaseType.communityVoting).status.isActive;

    if (campaign == null || page == null) {
      return;
    }

    final mappedPage = page.map(
      (proposalContext) {
        final proposal = proposalContext.proposal;
        final proposalWithContext = proposalContext.copyWith(
          user: proposalContext.user.copyWith(
            isFavorite: favoriteIds.contains(proposal.selfRef.id),
            lastCastedVote: Optional(lastCastedVote.forProposal(proposal.selfRef)),
          ),
        );
        return ProposalBriefVoting.fromProposalWithContext(
          proposalWithContext,
          draftVote: _ballotBuilder.getVoteOn(proposal.selfRef),
          showComments: showComments,
        );
      },
    );
    final signal = PageReadyVotingSignal(page: mappedPage);
    emitSignal(signal);
  }

  void _handleActiveAccountChange(Account? account) {
    if (account?.catalystId != _cache.filters.author) {
      changeFilters(author: Optional(account?.catalystId), resetProposals: true);
    }

    if (_cache.votingPower != account?.votingPower) {
      _cache = _cache.copyWith(votingPower: Optional(account?.votingPower));
      _dispatchState();
    }
  }

  void _handleBallotBuilderChange() {
    _emitCachedProposalsPage();
  }

  void _handleFavoriteProposalsIds(List<String> ids) {
    _cache = _cache.copyWith(favoriteIds: Optional(ids));
    _emitCachedProposalsPage();
    _dispatchState();
  }

  void _handleLastCastedChange(List<Vote>? vote) {
    _cache = _cache.copyWith(lastCastedVote: Optional(vote));
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

  Future<void> _loadFavoriteProposals() async {
    final favorites = await _proposalService.getFavoritesProposalsIds();
    if (!isClosed) {
      _handleFavoriteProposalsIds(favorites);
    }
  }

  Future<void> _loadLastCastedVotes() async {
    final lastCastedVotes = await _votingService.watchedCastedVotes().first;
    if (!isClosed) {
      _handleLastCastedChange(lastCastedVotes);
    }
  }

  Future<void> _loadVotingPower() async {
    await _userService.refreshActiveAccountVotingPower();
  }

  VotingState _rebuildState() {
    final campaign = _cache.campaign;
    final favoriteIds = _cache.favoriteIds ?? const [];
    final votingPower = _cache.votingPower;
    final categories = campaign?.categories ?? const [];
    final selectedCategoryRef = _cache.filters.category;
    final filters = _cache.filters;
    final count = _cache.count;

    final selectedCategory = campaign?.categories.firstWhereOrNull(
      (e) => e.selfRef.id == selectedCategoryRef?.id,
    );
    final selectedCategoryViewModel = selectedCategory != null
        ? CampaignCategoryDetailsViewModel.fromModel(selectedCategory)
        : null;
    final fundNumber = campaign?.fundNumber;
    final votingPowerViewModel = votingPower != null
        ? VotingPowerViewModel.fromModel(votingPower)
        : const VotingPowerViewModel();
    final votingPhaseViewModel = _buildVotingPhaseDetails(campaign);
    final hasSearchQuery = filters.searchQuery != null;
    final categorySelectorItems = _buildCategorySelectorItems(categories, selectedCategoryRef);

    return state.copyWith(
      selectedCategory: Optional(selectedCategoryViewModel),
      fundNumber: Optional(fundNumber),
      votingPower: votingPowerViewModel,
      votingPhase: Optional(votingPhaseViewModel),
      hasSearchQuery: hasSearchQuery,
      favoritesIds: favoriteIds,
      count: count,
      categorySelectorItems: categorySelectorItems,
    );
  }

  void _resetCache() {
    final activeAccount = _userService.user.activeAccount;
    final filters = ProposalsFilters.forActiveCampaign(author: activeAccount?.catalystId);

    _cache = VotingCubitCache(
      filters: filters,
      votingPower: activeAccount?.votingPower,
    );
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
