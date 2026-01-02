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
  bool _isLoadingActiveCampaign = false;

  CampaignPhaseAwareCubit(this._campaignService) : super(const LoadingCampaignPhaseAwareState()) {
    _campaignSubscription = _campaignService.watchActiveCampaign.distinct().listen(
      _handleActiveCampaignChange,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), _handleTimerTick);
  }

  CampaignPhaseType? activeCampaignPhaseType() {
    return state.activeCampaignPhaseType;
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
    try {
      _isLoadingActiveCampaign = true;

      emit(const LoadingCampaignPhaseAwareState());

      final campaign = await _campaignService.getActiveCampaign();
      if (isClosed) return;

      _handleActiveCampaignChange(campaign);
    } catch (error, stackTrace) {
      _logger.severe('Error getting active campaign', error, stackTrace);

      if (!isClosed) {
        emit(ErrorCampaignPhaseAwareState(error: LocalizedException.create(error)));
      }
    } finally {
      _isLoadingActiveCampaign = false;

      if (!isClosed) emit(_buildState());
    }
  }

  CampaignPhaseAwareState _buildState() {
    final isLoadingActiveCampaign = _isLoadingActiveCampaign;
    if (isLoadingActiveCampaign) {
      return const LoadingCampaignPhaseAwareState();
    }

    final activeCampaign = _activeCampaign;
    if (activeCampaign == null) {
      return const NoActiveCampaignPhaseAwareState();
    }

    return DataCampaignPhaseAwareState(
      activeCampaignPhaseType: activeCampaign.phaseType,
      phasesStates: activeCampaign.phasesStates,
      fundNumber: activeCampaign.fundNumber,
    );
  }

  void _handleActiveCampaignChange(Campaign? campaign) {
    if (_activeCampaign?.id == campaign?.id) return;

    _activeCampaign = campaign;
    emit(_buildState());
  }

  void _handleTimerTick(Timer timer) {
    emit(_buildState());
  }
}

extension on Campaign {
  List<CampaignPhaseState> get phasesStates {
    final now = DateTimeExt.now();

    return timeline.phases.map(
      (phase) {
        return CampaignPhaseState(
          phase: phase,
          status: CampaignPhaseStatus.fromRange(phase.timeline, now),
        );
      },
    ).toList();
  }

  CampaignPhaseType? get phaseType {
    return state.activePhases.firstOrNull?.phase.type;
  }
}
