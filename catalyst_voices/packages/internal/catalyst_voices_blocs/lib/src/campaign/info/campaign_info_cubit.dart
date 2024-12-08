import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Gets the campaign info.
final class CampaignInfoCubit extends Cubit<CampaignInfoState> {
  final CampaignService _campaignService;
  final AdminToolsCubit _adminToolsCubit;

  AdminToolsState _adminToolsState;
  StreamSubscription<AdminToolsState>? _adminToolsSub;

  CampaignInfoCubit(
    this._campaignService,
    this._adminToolsCubit,
  )   : _adminToolsState = _adminToolsCubit.state,
        super(const CampaignInfoState()) {
    _adminToolsSub = _adminToolsCubit.stream.listen(_onAdminToolsChanged);
  }

  /// Loads the currently active campaign.
  Future<void> load() async {
    emit(const CampaignInfoState(isLoading: true));

    final campaign = await _campaignService.getActiveCampaign();
    CampaignInfo? campaignInfo;

    if (campaign == null) {
      campaignInfo = null;
    } else if (_adminToolsState.enabled) {
      campaignInfo = _mockCampaign(campaign);
    } else {
      campaignInfo = CampaignInfo.fromCampaign(campaign, DateTimeExt.now());
    }

    if (!isClosed) {
      emit(CampaignInfoState(campaign: campaignInfo));
    }
  }

  @override
  Future<void> close() async {
    await _adminToolsSub?.cancel();
    _adminToolsSub = null;

    return super.close();
  }

  Future<void> _onAdminToolsChanged(AdminToolsState adminTools) async {
    _adminToolsState = adminTools;
    await load();
  }

  CampaignInfo _mockCampaign(Campaign campaign) {
    final campaignStage =
        CampaignStage.fromCampaign(campaign, DateTimeExt.now());
    if (_adminToolsState.campaignStage == campaignStage) {
      // campaign has already target stage, no need to mock it
      return CampaignInfo.fromCampaign(campaign, DateTimeExt.now());
    } else {
      return CampaignInfo.mockStageFromCampaign(
        campaign,
        _adminToolsState.campaignStage,
      );
    }
  }
}
