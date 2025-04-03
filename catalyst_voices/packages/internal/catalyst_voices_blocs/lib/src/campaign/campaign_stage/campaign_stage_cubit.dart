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

  CampaignStageCubit(this._campaignService)
      : super(const ProposalSubmissionStage()) {
    unawaited(getCampaignStage());
  }

  Future<void> getCampaignStage() async {
    try {
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
}
