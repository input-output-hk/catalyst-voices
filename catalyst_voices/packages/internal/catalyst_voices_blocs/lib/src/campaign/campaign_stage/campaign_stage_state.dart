import 'package:equatable/equatable.dart';

final class AfterProposalSubmissionStage extends CampaignStageState {
  const AfterProposalSubmissionStage();

  @override
  List<Object?> get props => [...super.props];
}

sealed class CampaignStageState extends Equatable {
  const CampaignStageState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [...super.props];
}
