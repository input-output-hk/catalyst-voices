import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'discovery_state.dart';

final _logger = Logger('DiscoveryCubit');

class DiscoveryCubit extends Cubit<DiscoveryState> with BlocErrorEmitterMixin {
  // ignore: unused_field
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  StreamSubscription<List<Proposal>>? _proposalsSubscription;
  StreamSubscription<List<String>>? _favoritesProposalsIdsSubscription;

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
    _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
    _favoritesProposalsIdsSubscription?.cancel();
    _favoritesProposalsIdsSubscription = null;
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
        campaignCategories: const DiscoveryCampaignCategoriesState(),
      ),
    );

    final categories = await _campaignService.getCampaignCategories();
    final categoriesModel =
        categories.map(CampaignCategoryDetailsViewModel.fromModel).toList();

    emit(
      state.copyWith(
        campaignCategories: DiscoveryCampaignCategoriesState(
          isLoading: false,
          categories: categoriesModel,
        ),
      ),
    );
  }

  Future<void> getCurrentCampaign() async {
    emit(
      state.copyWith(
        currentCampaign: const DiscoveryCurrentCampaignState(),
      ),
    );
    final campaign = await _campaignService.getCurrentCampaign();
    final campaignTimeline = await _campaignService.getCampaignTimeline();
    final currentCampaign = CurrentCampaignInfoViewModel.fromModel(campaign);

    emit(
      state.copyWith(
        currentCampaign: DiscoveryCurrentCampaignState(
          currentCampaign: currentCampaign,
          campaignTimeline: campaignTimeline,
          error: null,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> getMostRecentProposals() async {
    emit(
      state.copyWith(
        mostRecentProposals: const DiscoveryMostRecentProposalsState(),
      ),
    );

    await _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
    _setupProposalsSubscription();

    await _favoritesProposalsIdsSubscription?.cancel();
    _favoritesProposalsIdsSubscription = null;
    _setupFavoritesProposalsIdsSubscription();

    final mostRecentState = state.mostRecentProposals;
    emit(
      state.copyWith(
        mostRecentProposals: mostRecentState.copyWith(isLoading: false),
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

  void _emitFavoritesIds(List<String> ids) {
    final proposals = state.mostRecentProposals.proposals;

    final newProposals = [...proposals]
        .map((e) => e.copyWith(isFavorite: ids.contains(e.ref.id)))
        .toList();

    emit(
      state.copyWith(
        mostRecentProposals: state.mostRecentProposals.copyWith(
          proposals: newProposals,
        ),
      ),
    );
  }

  void _emitMostRecentError(Object error) {
    emit(
      state.copyWith(
        mostRecentProposals: state.mostRecentProposals.copyWith(
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
          ),
        )
        .toList();
    emit(
      state.copyWith(
        mostRecentProposals: state.mostRecentProposals.copyWith(
          isLoading: false,
          error: null,
          proposals: proposalList,
        ),
      ),
    );
  }

  void _setupFavoritesProposalsIdsSubscription() {
    _logger.info('Setting up favorites proposals ids subscription');
    _favoritesProposalsIdsSubscription =
        _proposalService.watchFavoritesProposalsIds().listen(
      _emitFavoritesIds,
      onError: (Object error) {
        _emitMostRecentError(error);
      },
    );
  }

  void _setupProposalsSubscription() {
    _logger.fine('Setting up proposals subscription');
    _proposalsSubscription =
        _proposalService.watchLatestProposals(limit: 7).listen(
      (proposals) async {
        _logger.finest('Got proposals: ${proposals.length}');
        _emitMostRecentProposals(proposals);
        final currentFavorites =
            await _proposalService.watchFavoritesProposalsIds().first;
        _emitFavoritesIds(currentFavorites);
      },
      onError: (Object error) {
        _emitMostRecentError(error);
      },
    );
  }
}
