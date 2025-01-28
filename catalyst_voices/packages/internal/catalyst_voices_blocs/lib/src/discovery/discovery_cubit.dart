import 'dart:math';

import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
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
    ]);
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

    final currentCampaign = CurrentCampaignInfoViewModel.dummy();

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
}
