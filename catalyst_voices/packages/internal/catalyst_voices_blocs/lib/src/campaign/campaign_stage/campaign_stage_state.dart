import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class AfterProposalSubmissionStage extends CampaignStageState {
  const AfterProposalSubmissionStage();
}

sealed class CampaignStageState extends Equatable {
  const CampaignStageState();

  @override
  List<Object?> get props => [];
}

final class ErrorSubmissionStage extends CampaignStageState {
  final LocalizedException error;

  const ErrorSubmissionStage(this.error);

  @override
  List<Object?> get props => [...super.props, error];
}

final class LoadingCampaignStage extends CampaignStageState {
  const LoadingCampaignStage();
}

final class PreProposalSubmissionStage extends CampaignStageState {
  final DateTime? startDate;

  const PreProposalSubmissionStage({
    this.startDate,
  });

  @override
  List<Object?> get props => [...super.props, startDate];
}

final class ProposalSubmissionStage extends CampaignStageState {
  const ProposalSubmissionStage();
}
