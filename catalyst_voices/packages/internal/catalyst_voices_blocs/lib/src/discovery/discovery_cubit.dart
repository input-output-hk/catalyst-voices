import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/discovery/discovery_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

const _maxRecentProposalsCount = 7;
const List<CampaignPhaseType> _offstagePhases = [CampaignPhaseType.reviewRegistration];

final _logger = Logger('DiscoveryCubit');

/// Manages all data for the discovery screen.
///
/// Communicates with the services to get the data and emits it to the UI.
class DiscoveryCubit extends Cubit<DiscoveryState> with BlocErrorEmitterMixin {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  DiscoveryCubitCache _cache = const DiscoveryCubitCache();

  StreamSubscription<List<ProposalBrief>>? _proposalsV2Sub;
  StreamSubscription<Campaign?>? _activeCampaignSub;

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
  Future<void> close() async {
    await _proposalsV2Sub?.cancel();
    _proposalsV2Sub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    return super.close();
  }

  Future<void> getAllData() async {
    getMostRecentProposals();
    await getCurrentCampaign();
  }

  Future<void> getCurrentCampaign() async {
    try {
      emit(state.copyWith(campaign: const DiscoveryCampaignState(isLoading: true)));

      final campaign = await _campaignService.getActiveCampaign();

      if (!isClosed) {
        _handleActiveCampaignChange(campaign);
        _watchActiveCampaign();
      }
    } catch (e, st) {
      _logger.severe('Error getting current campaign', e, st);

      if (!isClosed) {
        final campaignState = DiscoveryCampaignState(error: LocalizedException.create(e));
        emit(state.copyWith(campaign: campaignState));
      }
    }
  }

  void getMostRecentProposals() {
    emit(state.copyWith(proposals: const DiscoveryMostRecentProposalsState()));

    _watchMostRecentProposals();
  }

  Future<void> removeFavorite(DocumentRef ref) async {
    try {
      await _proposalService.removeFavoriteProposal(ref: ref);
    } catch (e, st) {
      _logger.severe('Error adding favorite', e, st);
      emitError(LocalizedException.create(e));
    }
  }

  CampaignDatesEventsState _buildCampaignDatesEvents(
    List<CampaignTimelineViewModel> campaignTimeline,
  ) {
    final reviewItems =
        [
              campaignTimeline.firstWhereOrNull(
                (e) => e.type == CampaignPhaseType.reviewRegistration,
              ),
              campaignTimeline.firstWhereOrNull(
                (e) => e.type == CampaignPhaseType.communityReview,
              ),
            ]
            .whereType<CampaignTimelineViewModel>()
            .map(
              (e) => CampaignTimelineEventWithTitle(
                dateRange: e.timeline,
                type: e.type,
              ),
            )
            .toList();

    final votingItems =
        [
              campaignTimeline.firstWhereOrNull(
                (e) => e.type == CampaignPhaseType.votingRegistration,
              ),
              campaignTimeline.firstWhereOrNull(
                (e) => e.type == CampaignPhaseType.communityVoting,
              ),
            ]
            .whereType<CampaignTimelineViewModel>()
            .map(
              (e) => CampaignTimelineEventWithTitle(
                dateRange: e.timeline,
                type: e.type,
              ),
            )
            .toList();

    return CampaignDatesEventsState(
      reviewTimelineItems: reviewItems,
      votingTimelineItems: votingItems,
    );
  }

  void _handleActiveCampaignChange(Campaign? campaign) {
    if (_cache.activeCampaign?.selfRef == campaign?.selfRef) {
      return;
    }

    _cache = _cache.copyWith(activeCampaign: Optional(campaign));

    final phases = campaign?.timeline.phases ?? [];
    final timeline = phases
        .where((phase) => !_offstagePhases.contains(phase.type))
        .map(CampaignTimelineViewModel.fromModel)
        .toList();
    final datesEvents = _buildCampaignDatesEvents(timeline);

    final currentCampaign = CurrentCampaignInfoViewModel(
      title: campaign?.name ?? '',
      allFunds:
          campaign?.allFunds ??
          MultiCurrencyAmount.single(Money.zero(currency: Currencies.fallback)),
      totalAsk: MultiCurrencyAmount.single(Money.zero(currency: Currencies.fallback)),
      timeline: timeline,
    );

    final categories = campaign?.categories ?? [];
    final categoriesModel = categories.map(CampaignCategoryDetailsViewModel.fromModel).toList();

    final campaignState = DiscoveryCampaignState(
      currentCampaign: currentCampaign,
      campaignTimeline: timeline,
      categories: categoriesModel,
      datesEvents: datesEvents,
    );

    emit(state.copyWith(campaign: campaignState));
  }

  void _handleProposalsChange(List<ProposalBrief> proposals) {
    _logger.finest('Got proposals[${proposals.length}]');

    final updatedProposalsState = state.proposals.copyWith(
      proposals: proposals,
      showSection: proposals.length == _maxRecentProposalsCount,
    );

    emit(state.copyWith(proposals: updatedProposalsState));
  }

  void _watchActiveCampaign() {
    unawaited(_activeCampaignSub?.cancel());

    _activeCampaignSub = _campaignService.watchActiveCampaign
        .distinct((previous, next) => previous?.selfRef != next?.selfRef)
        .listen(_handleActiveCampaignChange);
  }

  void _watchMostRecentProposals() {
    unawaited(_proposalsV2Sub?.cancel());

    _proposalsV2Sub = _proposalService
        .watchProposalsBriefPageV2(
          request: const PageRequest(page: 0, size: _maxRecentProposalsCount),
        )
        .map((page) => page.items)
        .distinct(listEquals)
        .map((items) => items.map(ProposalBrief.fromData).toList())
        .listen(_handleProposalsChange);
  }
}
