import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final _logger = Logger('CampaignPhaseAwareCubit');

final class CampaignPhaseAwareCubit extends Cubit<CampaignPhaseAwareState> {
  final CampaignService _campaignService;
  StreamSubscription<Campaign>? _campaignSubscription;

  CampaignPhaseAwareCubit(this._campaignService) : super(const LoadingCampaignPhaseAwareState()) {
    _campaignSubscription =
        _campaignService.watchActiveCampaign.distinct().listen(_handleCampaignChange);
    unawaited(getActiveCampaign());
  }

  @override
  Future<void> close() async {
    await _campaignSubscription?.cancel();
    _campaignSubscription = null;
    return super.close();
  }

  Future<void> getActiveCampaign() async {
    emit(const LoadingCampaignPhaseAwareState());
    try {
      final campaign = await _campaignService.getActiveCampaign();
      _handleCampaignChange(campaign);
    } catch (error, stackTrace) {
      _logger.severe('Error getting active campaign', error, stackTrace);
      emit(ErrorCampaignPhaseAwareState(error: LocalizedException.create(error)));
    }
  }

  void _handleCampaignChange(Campaign? campaign) {
    if (campaign == null) {
      emit(const LoadingCampaignPhaseAwareState());
    } else if (!isClosed) {
      emit(DataCampaignPhaseAwareState(campaign: campaign));
    }
  }
}
