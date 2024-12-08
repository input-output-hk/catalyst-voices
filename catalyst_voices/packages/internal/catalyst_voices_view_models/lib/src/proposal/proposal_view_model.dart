import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/campaign/campaign_stage.dart';
import 'package:catalyst_voices_view_models/src/proposal/funded_proposal.dart';
import 'package:catalyst_voices_view_models/src/proposal/pending_proposal.dart';
import 'package:equatable/equatable.dart';

/// A proposal view model spanning proposals in different stages.
sealed class ProposalViewModel extends Equatable {
  const ProposalViewModel();

  factory ProposalViewModel.fromProposalAtStage({
    required Proposal proposal,
    required String campaignName,
    required CampaignStage campaignStage,
  }) {
    switch (campaignStage) {
      case CampaignStage.draft:
      case CampaignStage.scheduled:
      case CampaignStage.live:
        return PendingProposalViewModel(
          data: PendingProposal.fromProposal(
            proposal,
            campaignName: campaignName,
          ),
        );
      case CampaignStage.completed:
        // TODO(dtscalac): whether proposal is funded or not should depend
        // not on campaign stage but on the proposal properties.
        // In the future when proposals are refined update this.
        return FundedProposalViewModel(
          data: FundedProposal.fromProposal(
            proposal,
            campaignName: campaignName,
          ),
        );
    }
  }

  String get id;
}

final class PendingProposalViewModel extends ProposalViewModel {
  final PendingProposal data;

  const PendingProposalViewModel({required this.data});

  @override
  String get id => data.id;

  @override
  List<Object?> get props => [data];
}

final class FundedProposalViewModel extends ProposalViewModel {
  final FundedProposal data;

  const FundedProposalViewModel({required this.data});

  @override
  String get id => data.id;

  @override
  List<Object?> get props => [data];
}
