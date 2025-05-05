import 'dart:async';

import 'package:catalyst_voices_blocs/src/campaign/campaign_stage/campaign_stage_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('CampaignStageCubit');

class CampaignStageCubit extends Cubit<CampaignStageState> {
  final CampaignService _campaignService;
  late Timer? _timer;

  CampaignStageCubit(this._campaignService)
      : super(const LoadingCampaignStage()) {
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
      final campaignTimeline = await _campaignService.getCampaignTimeline();

      final now = DateTime.now();
      final proposalSubmissionStage = campaignTimeline.firstWhere(
        (e) => e.stage == CampaignTimelineStage.proposalSubmission,
        orElse: () => throw const NotFoundException(
          message: 'Proposal submission stage not found',
        ),
      );

      if (proposalSubmissionStage.timeline.isInRange(now)) {
        emit(const ProposalSubmissionStage());
        _startCountdownTimer(proposalSubmissionStage.timeline.to);
      } else if (proposalSubmissionStage.timeline.isBeforeRange(now)) {
        emit(
          PreProposalSubmissionStage(
            startDate: proposalSubmissionStage.timeline.from,
          ),
        );
      } else {
        emit(const AfterProposalSubmissionStage());
      }
      _logger.info(state.toString());
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
