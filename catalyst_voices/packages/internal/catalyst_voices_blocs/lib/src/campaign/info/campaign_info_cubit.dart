import 'dart:async';

import 'package:catalyst_voices_blocs/src/campaign/info/campaign_info.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Gets the campaign info.
final class CampaignInfoCubit extends Cubit<CampaignInfoState> {
  final CampaignRepository campaignRepository;

  CampaignInfoCubit({required this.campaignRepository})
      : super(const LoadingCampaignInfoState());

  /// Loads the currently active campaign.
  Future<void> load() async {
    final campaign = await campaignRepository.getActiveCampaign();

    emit(
      LoadedCampaignInfoState(
        campaign: campaign != null ? CampaignInfo.fromCampaign(campaign) : null,
      ),
    );
  }
}
