import 'dart:math';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'discovery_state.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  // ignore: unused_field
  final CampaignService _campaignService;
  DiscoveryCubit(this._campaignService) : super(const DiscoveryState());

  Future<void> getAllData() async {
    await Future.wait([
      getCurrentCampaign(),
      getCampaignCategories(),
      getMostRecentProposals(),
    ]);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  Future<void> getCurrentCampaign() async {
    emit(
      state.copyWith(
        currentCampaign: const DiscoveryCurrentCampaignState(),
      ),
    );

    final isSuccess = await Future.delayed(
      const Duration(seconds: 2),
      () => Random().nextBool(),
    );
    if (isClosed) return;

    final currentCampaign = isSuccess
        ? CurrentCampaignInfoViewModel.dummy()
        : const NullCurrentCampaignInfoViewModel();

    final error = isSuccess ? null : const LocalizedUnknownException();

    emit(
      state.copyWith(
        currentCampaign: DiscoveryCurrentCampaignState(
          currentCampaign: currentCampaign,
          error: error,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> getCampaignCategories() async {
    emit(
      state.copyWith(
        campaignCategories: const DiscoveryCampaignCategoriesState(),
      ),
    );

    final isSuccess = await Future.delayed(
      const Duration(seconds: 1),
      () => Random().nextBool(),
    );
    if (isClosed) return;

    final categories = isSuccess
        ? List.generate(
            6, (index) => CampaignCategoryViewModel.dummy(id: index.toString()))
        : <CampaignCategoryViewModel>[];

    final error = isSuccess ? null : const LocalizedUnknownException();

    emit(
      state.copyWith(
        campaignCategories: DiscoveryCampaignCategoriesState(
          isLoading: false,
          error: error,
          categories: categories,
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

    final isSuccess = await Future.delayed(
      const Duration(seconds: 1),
      () => Random().nextBool(),
    );
    if (isClosed) return;

    // isSuccess = false;

    final proposals = isSuccess
        ? List<PendingProposal>.filled(
            7,
            PendingProposal.dummy(),
          )
        : const <PendingProposal>[];

    final error = isSuccess ? null : const LocalizedUnknownException();

    final newState = state.copyWith(
      mostRecentProposals: DiscoveryMostRecentProposalsState(
        isLoading: false,
        error: error,
        proposals: proposals,
      ),
    );

    emit(newState);
  }

  CampaignCategoryViewModel? localCategory(String id) {
    return state.campaignCategories.categories
        .firstWhereOrNull((e) => e.id == id);
  }
}
