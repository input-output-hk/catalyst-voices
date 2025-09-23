import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

const _maxRecentProposalsCount = 7;
final _logger = Logger('DiscoveryCubit');

/// Manages all data for the discovery screen.
///
/// Communicates with the services to get the data and emits it to the UI.
class DiscoveryCubit extends Cubit<DiscoveryState> with BlocErrorEmitterMixin {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  StreamSubscription<List<Proposal>>? _proposalsSub;
  StreamSubscription<List<String>>? _favoritesProposalsIdsSub;

  DiscoveryCubit(this._campaignService, this._proposalService) : super(const DiscoveryState());

  Future<void> addFavorite(DocumentRef ref) async {
    try {
      await _proposalService.addFavoriteProposal(ref: ref);
    } catch (e, st) {
      _logger.severe('Error adding favorite', e, st);
      emitError(LocalizedException.create(e));
    }
  }

  @override
  Future<void> close() async {
    await _proposalsSub?.cancel();
    _proposalsSub = null;

    await _favoritesProposalsIdsSub?.cancel();
    _favoritesProposalsIdsSub = null;

    return super.close();
  }

  Future<void> getAllData() async {
    await Future.wait([
      getCurrentCampaign(),
      getMostRecentProposals(),
    ]);
  }

  Future<void> getCurrentCampaign() async {
    try {
      emit(
        state.copyWith(
          campaign: const DiscoveryCampaignState(),
        ),
      );
      final campaign = (await _campaignService.getActiveCampaign())!;
      final timeline = campaign.timeline.phases.map(CampaignTimelineViewModel.fromModel).toList();
      final currentCampaign = CurrentCampaignInfoViewModel.fromModel(campaign);
      final categoriesModel = campaign.categories
          .map(CampaignCategoryDetailsViewModel.fromModel)
          .toList();

      if (!isClosed) {
        emit(
          state.copyWith(
            campaign: DiscoveryCampaignState(
              currentCampaign: currentCampaign,
              campaignTimeline: timeline,
              categories: categoriesModel,
              isLoading: false,
            ),
          ),
        );
      }
    } catch (e, st) {
      _logger.severe('Error getting current campaign', e, st);

      if (!isClosed) {
        emit(
          state.copyWith(
            campaign: DiscoveryCampaignState(error: LocalizedException.create(e)),
          ),
        );
      }
    }
  }

  Future<void> getMostRecentProposals() async {
    try {
      unawaited(_proposalsSub?.cancel());
      unawaited(_favoritesProposalsIdsSub?.cancel());

      emit(state.copyWith(proposals: const DiscoveryMostRecentProposalsState()));
      final campaign = await _campaignService.getActiveCampaign();
      if (!isClosed) {
        _proposalsSub = _buildProposalsSub();
        _favoritesProposalsIdsSub = _buildFavoritesProposalsIdsSub();

        emit(
          state.copyWith(
            proposals: state.proposals.copyWith(
              isLoading: false,
              showComments: campaign?.supportsComments ?? false,
            ),
          ),
        );
      }
    } catch (e, st) {
      _logger.severe('Error getting most recent proposals', e, st);

      if (!isClosed) {
        emit(
          state.copyWith(
            proposals: DiscoveryMostRecentProposalsState(error: LocalizedException.create(e)),
          ),
        );
      }
    }
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

    return _proposalService
        .watchFavoritesProposalsIds()
        .distinct(listEquals)
        .listen(
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
          order: const UpdateDate(isAscending: false),
        )
        .map((event) => event.items)
        .distinct(listEquals)
        .listen(_handleProposals, onError: _emitMostRecentError);
  }

  void _emitFavoritesIds(List<String> ids) {
    emit(state.copyWith(proposals: state.proposals.updateFavorites(ids)));
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
          (e) => ProposalBrief.fromProposal(
            e,
            isFavorite: state.proposals.favoritesIds.contains(e.selfRef.id),
            showComments: state.proposals.showComments,
          ),
        )
        .toList();

    emit(
      state.copyWith(
        proposals: state.proposals.copyWith(
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
