import 'dart:async';

import 'package:catalyst_voices_blocs/src/campaign/campaign_stage/campaign_stage_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('CampaignStageCubit');

/// Manages the campaign stage.
///
/// This Cubit can lock down the application when the campaign is not in the proposal
/// submission stage.
class CampaignStageCubit extends Cubit<CampaignStageState> {
  final CampaignService _campaignService;
  Timer? _timer;

  CampaignStageCubit(this._campaignService) : super(const LoadingCampaignStage()) {
    unawaited(getCampaignStage());
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    _timer = null;
    await super.close();
  }

  Future<void> getCampaignStage() async {
    try {
      emit(const LoadingCampaignStage());
      final campaignTimeline = await _campaignService.getCampaignTimelineByStage(
        CampaignTimelineStage.proposalSubmission,
      );
      final dateRangeStatus = campaignTimeline.timeline.rangeStatusNow();
      final startDate = campaignTimeline.timeline.from;
      final endDate = campaignTimeline.timeline.to;

      return switch (dateRangeStatus) {
        DateRangeStatus.after => emit(const AfterProposalSubmissionStage()),
        DateRangeStatus.before => emit(PreProposalSubmissionStage(startDate: startDate)),
        DateRangeStatus.inRange => {
            _startCountdownTimer(endDate),
            emit(const ProposalSubmissionStage()),
          }
      };
    } catch (error, stackTrace) {
      _logger.severe('getCampaignStage error', error, stackTrace);
      emit(const ErrorSubmissionStage(LocalizedUnknownException()));
    }
  }

  void proposalSubmissionStarted() {
    emit(const ProposalSubmissionStage());
  }

  void _startCountdownTimer(DateTime? endTime) {
    if (endTime == null) {
      return;
    }
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(endTime)) {
        timer.cancel();
        emit(const AfterProposalSubmissionStage());
      }
    });
  }
}
