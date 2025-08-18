import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final _logger = Logger('CampaignPhaseAwareCubit');

final class CampaignPhaseAwareCubit extends Cubit<CampaignPhaseAwareState> {
  final CampaignService _campaignService;
  StreamSubscription<Campaign?>? _campaignSubscription;
  Campaign? _activeCampaign;
  Timer? _timer;

  CampaignPhaseAwareCubit(this._campaignService) : super(const LoadingCampaignPhaseAwareState()) {
    _campaignSubscription = _campaignService.watchActiveCampaign.distinct().listen(
      _handleCampaignChange,
    );
    unawaited(getActiveCampaign());
    _timer = Timer.periodic(const Duration(seconds: 1), _handleTimerTick);
  }

  Future<CampaignPhaseType?> activeCampaignPhaseType() async {
    await for (final currentState in stream) {
      if (currentState is DataCampaignPhaseAwareState) {
        return currentState.activeCampaignPhaseType;
      } else if (currentState is ErrorCampaignPhaseAwareState) {
        return null;
      }
    }

    return null;
  }

  @override
  Future<void> close() async {
    await _campaignSubscription?.cancel();
    _campaignSubscription = null;
    _timer?.cancel();
    _timer = null;
    return super.close();
  }

  Future<void> getActiveCampaign() async {
    emit(const LoadingCampaignPhaseAwareState());
    try {
      final campaign = await _campaignService.getActiveCampaign();

      if (isClosed) return;

      if (campaign == null) {
        return emit(const NoActiveCampaignPhaseAwareState());
      }
      _handleCampaignChange(campaign);
    } catch (error, stackTrace) {
      _logger.severe('Error getting active campaign', error, stackTrace);
      emit(ErrorCampaignPhaseAwareState(error: LocalizedException.create(error)));
    }
  }

  CampaignPhaseType? _activeCampaignPhaseType() {
    if (_activeCampaign == null) return null;
    return _activeCampaign!.state.activePhases.firstOrNull?.phase.type;
  }

  // ignore: use_setters_to_change_properties
  void _handleCampaignChange(Campaign? campaign) {
    _activeCampaign = campaign;
  }

  void _handleTimerTick(Timer timer) {
    if (_activeCampaign == null) return;
    final phasesStates = <CampaignPhaseState>[];

    for (final phase in _activeCampaign!.timeline.phases) {
      phasesStates.add(
        CampaignPhaseState(
          phase: phase,
          status: CampaignPhaseStatus.fromRange(phase.timeline, DateTimeExt.now()),
        ),
      );
    }

    final activeCampaignPhaseType = _activeCampaignPhaseType();

    emit(
      DataCampaignPhaseAwareState(
        activeCampaignPhaseType: activeCampaignPhaseType,
        phasesStates: phasesStates,
        fundNumber: _activeCampaign!.fundNumber,
      ),
    );
  }
}
