import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

const _maxRecentProposalsCount = 7;
final _logger = Logger('DiscoveryCubit');

class DiscoveryCubit extends Cubit<DiscoveryState> with BlocErrorEmitterMixin {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  StreamSubscription<List<Proposal>>? _proposalsSub;
  StreamSubscription<List<String>>? _favoritesProposalsIdsSub;

  DiscoveryCubit(
    this._campaignService,
    this._proposalService,
  ) : super(const DiscoveryState());

  Future<void> addFavorite(DocumentRef ref) async {
    try {
      await _proposalService.addFavoriteProposal(ref: ref);
    } catch (e, st) {
      _logger.severe('Error adding favorite', e, st);
      emitError(LocalizedException.create(e));
    }
  }

  @override
  Future<void> close() {
    _proposalsSub?.cancel();
    _proposalsSub = null;

    _favoritesProposalsIdsSub?.cancel();
    _favoritesProposalsIdsSub = null;

    return super.close();
  }

  Future<void> getAllData() async {
    await Future.wait([
      getCurrentCampaign(),
      getCampaignCategories(),
      getMostRecentProposals(),
    ]);
  }

  Future<void> getCampaignCategories() async {
    emit(
      state.copyWith(
        categories: const DiscoveryCampaignCategoriesState(),
      ),
    );

    final categories = await _campaignService.getCampaignCategories();
    final categoriesModel = categories.map(CampaignCategoryDetailsViewModel.fromModel).toList();

    // TODO(damian-molinski): create VoicesBloc / VoicesCubit where this
    // always will be checked.
    if (!isClosed) {
      emit(
        state.copyWith(
          categories: DiscoveryCampaignCategoriesState(
            isLoading: false,
            categories: categoriesModel,
          ),
        ),
      );
    }
  }

  Future<void> getCurrentCampaign() async {
    emit(
      state.copyWith(
        campaign: const DiscoveryCurrentCampaignState(),
      ),
    );
    final campaign = await _campaignService.getCurrentCampaign();
    final campaignTimeline = await _campaignService.getCampaignTimeline();
    final currentCampaign = CurrentCampaignInfoViewModel.fromModel(campaign);

    if (!isClosed) {
      emit(
        state.copyWith(
          campaign: DiscoveryCurrentCampaignState(
            currentCampaign: currentCampaign,
            campaignTimeline: campaignTimeline,
            isLoading: false,
          ),
        ),
      );
    }
  }

  Future<void> getMostRecentProposals() async {
    emit(
      state.copyWith(
        proposals: const DiscoveryMostRecentProposalsState(),
      ),
    );

    unawaited(_proposalsSub?.cancel());
    _proposalsSub = _buildProposalsSub();

    unawaited(_favoritesProposalsIdsSub?.cancel());
    _favoritesProposalsIdsSub = _buildFavoritesProposalsIdsSub();

    final mostRecentState = state.proposals;
    emit(
      state.copyWith(
        proposals: mostRecentState.copyWith(isLoading: false),
      ),
    );
  }

  Future<void> removeFavorite(DocumentRef ref) async {
    try {
      await _proposalService.removeFavoriteProposal(ref: ref);
    } catch (e, st) {
      _logger.severe('Error adding favorite', e, st);
      emitError(LocalizedException.create(e));
    }
  }

  StreamSubscription<List<String>> _buildFavoritesProposalsIdsSub() {
    _logger.info('Building favorites proposals ids subscription');

    return _proposalService.watchFavoritesProposalsIds().distinct(listEquals).listen(
          _emitFavoritesIds,
          onError: _emitMostRecentError,
        );
  }

  StreamSubscription<List<Proposal>> _buildProposalsSub() {
    _logger.fine('Building proposals subscription');

    return _proposalService
        .watchProposalsPage(
          request: const PageRequest(page: 0, size: _maxRecentProposalsCount),
          filters: const ProposalsFilters(),
        )
        .map((event) => event.items)
        .distinct(listEquals)
        .listen(
          _handleProposals,
          onError: _emitMostRecentError,
        );
  }

  void _emitFavoritesIds(List<String> ids) {
    emit(
      state.copyWith(proposals: state.proposals.updateFavorites(ids)),
    );
  }

  void _emitMostRecentError(Object error, StackTrace stackTrace) {
    _logger.severe('Loading recent proposals emitted', error, stackTrace);

    emit(
      state.copyWith(
        proposals: state.proposals.copyWith(
          isLoading: false,
          error: LocalizedException.create(error),
          proposals: const [],
        ),
      ),
    );
  }

  void _emitMostRecentProposals(List<Proposal> proposals) {
    final proposalList = proposals
        .map(
          (e) => PendingProposal.fromProposal(
            e,
            campaignName: 'f14',
            isFavorite: state.proposals.favoritesIds.contains(e.selfRef.id),
          ),
        )
        .toList();

    emit(
      state.copyWith(
        proposals: state.proposals.copyWith(
          isLoading: false,
          proposals: proposalList,
        ),
      ),
    );
  }

  Future<void> _handleProposals(List<Proposal> proposals) async {
    _logger.info('Got proposals: ${proposals.length}');

    _emitMostRecentProposals(proposals);
  }
}
