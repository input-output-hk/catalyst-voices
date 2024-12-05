import 'dart:async';

import 'package:catalyst_voices_blocs/src/campaign/info/campaign_info.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Gets the campaign info.
final class CampaignInfoCubit extends Cubit<CampaignInfoState> {
  final CampaignService campaignService;

  CampaignInfoCubit({required this.campaignService})
      : super(const CampaignInfoState());

  /// Loads the currently active campaign.
  Future<void> load() async {
    emit(const CampaignInfoState(isLoading: true));

    final campaign = await campaignService.getActiveCampaign();

    emit(
      CampaignInfoState(
        campaign: campaign != null
            ? CampaignInfo.fromCampaign(campaign, DateTimeExt.now())
            : null,
      ),
    );
  }
}
