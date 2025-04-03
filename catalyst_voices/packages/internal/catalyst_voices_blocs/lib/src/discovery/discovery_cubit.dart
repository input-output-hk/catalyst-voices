import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'discovery_state.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  // ignore: unused_field
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  StreamSubscription<List<Proposal>>? _proposalsSubscription;

  DiscoveryCubit(
    this._campaignService,
    this._proposalService,
  ) : super(const DiscoveryState());

  @override
  Future<void> close() {
    _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
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
  }

  void _setupProposalsSubscription() {
    _proposalsSubscription =
        _proposalService.watchLatestProposals(limit: 7).listen(
      (proposals) {
        if (isClosed) return;
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
            mostRecentProposals: DiscoveryMostRecentProposalsState(
              isLoading: false,
              error: null,
              proposals: proposalList,
            ),
          ),
        );
      },
      onError: (Object error) {
        if (isClosed) return;
        emit(
          state.copyWith(
            mostRecentProposals: DiscoveryMostRecentProposalsState(
              isLoading: false,
              error: LocalizedException.create(error),
              proposals: const [],
            ),
          ),
        );
      },
    );
    emit(
      state.copyWith(
        mostRecentProposals:
            const DiscoveryMostRecentProposalsState(isLoading: false),
      ),
    );
  }
}
